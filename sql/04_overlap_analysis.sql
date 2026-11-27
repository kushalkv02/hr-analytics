-- Step 4: overlap analysis. Does overtime stand on its own, or sit inside other high-attrition groups?
-- Rate = leavers / employees in the cell. Cells under 30 employees are flagged: do not over-read them.
-- Plain CASE/aggregate SQL, so it runs on PostgreSQL and MySQL.

-- O1 Overtime x job role: headcount, rate and the gap in percentage points (Yes minus No)
SELECT job_role,
       SUM(CASE WHEN overtime = 'Yes' THEN 1 ELSE 0 END)                    AS ot_yes_n,
       SUM(CASE WHEN overtime = 'Yes' THEN attrition_flag ELSE 0 END)       AS ot_yes_leavers,
       ROUND(100.0 * SUM(CASE WHEN overtime = 'Yes' THEN attrition_flag ELSE 0 END)
             / NULLIF(SUM(CASE WHEN overtime = 'Yes' THEN 1 ELSE 0 END), 0), 2) AS ot_yes_rate_pct,
       SUM(CASE WHEN overtime = 'No' THEN 1 ELSE 0 END)                     AS ot_no_n,
       SUM(CASE WHEN overtime = 'No' THEN attrition_flag ELSE 0 END)        AS ot_no_leavers,
       ROUND(100.0 * SUM(CASE WHEN overtime = 'No' THEN attrition_flag ELSE 0 END)
             / NULLIF(SUM(CASE WHEN overtime = 'No' THEN 1 ELSE 0 END), 0), 2)  AS ot_no_rate_pct,
       ROUND(100.0 * SUM(CASE WHEN overtime = 'Yes' THEN attrition_flag ELSE 0 END)
             / NULLIF(SUM(CASE WHEN overtime = 'Yes' THEN 1 ELSE 0 END), 0)
           - 100.0 * SUM(CASE WHEN overtime = 'No' THEN attrition_flag ELSE 0 END)
             / NULLIF(SUM(CASE WHEN overtime = 'No' THEN 1 ELSE 0 END), 0), 2) AS gap_pp,
       CASE WHEN SUM(CASE WHEN overtime = 'Yes' THEN 1 ELSE 0 END) < 30
              OR SUM(CASE WHEN overtime = 'No'  THEN 1 ELSE 0 END) < 30
            THEN 'small group' ELSE '' END                                   AS flag
FROM hr_employee
GROUP BY job_role
ORDER BY gap_pp DESC;

-- O2 Overtime x tenure band
SELECT tenure_band, overtime,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee
GROUP BY tenure_band, overtime
ORDER BY MIN(years_at_company), overtime;

-- O3 Overtime x age band
SELECT age_band, overtime,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee
GROUP BY age_band, overtime
ORDER BY MIN(age), overtime;

-- O4 Overtime x business travel
SELECT business_travel, overtime,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee
GROUP BY business_travel, overtime
ORDER BY business_travel, overtime;

-- O5 Overtime x department
SELECT department, overtime,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee
GROUP BY department, overtime
ORDER BY department, overtime;

-- O6 Three-way overlap: overtime x early tenure (< 5 years) x frequent travel
-- Shows how much attrition concentrates in combined groups, and how big those groups are.
SELECT overtime,
       CASE WHEN years_at_company < 5 THEN 'Under 5 yrs' ELSE '5+ yrs' END AS tenure_group,
       CASE WHEN business_travel = 'Travel_Frequently' THEN 'Frequent travel' ELSE 'Other travel' END AS travel_group,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       ROUND(100.0 * COUNT(*) / NULLIF(SUM(COUNT(*)) OVER (), 0), 2) AS share_of_employees_pct,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(SUM(SUM(attrition_flag)) OVER (), 0), 2) AS share_of_all_leavers_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee
GROUP BY overtime,
         CASE WHEN years_at_company < 5 THEN 'Under 5 yrs' ELSE '5+ yrs' END,
         CASE WHEN business_travel = 'Travel_Frequently' THEN 'Frequent travel' ELSE 'Other travel' END
ORDER BY attrition_rate_pct DESC;

-- O7 Reconciliation (expected: 0 and 0): overlap cells must add back to the overall totals
SELECT (SELECT COUNT(*) FROM hr_employee) - (SELECT SUM(c) FROM (SELECT COUNT(*) c FROM hr_employee GROUP BY job_role, overtime) a) AS headcount_diff,
       (SELECT SUM(attrition_flag) FROM hr_employee) - (SELECT SUM(l) FROM (SELECT SUM(attrition_flag) l FROM hr_employee GROUP BY tenure_band, overtime) b) AS leaver_diff;
