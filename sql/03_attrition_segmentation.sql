-- Step 3: segment attrition. Rate = leavers in segment / employees in segment.
-- share_of_all_leavers is shown separately so rate and impact are not confused.
-- small_group flags segments under 30 employees (rates unstable; qualify conclusions).

-- S1 Department
SELECT department,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(SUM(SUM(attrition_flag)) OVER (), 0), 2) AS share_of_all_leavers_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee GROUP BY department ORDER BY attrition_rate_pct DESC;

-- S2 Job role
SELECT job_role,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(SUM(SUM(attrition_flag)) OVER (), 0), 2) AS share_of_all_leavers_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee GROUP BY job_role ORDER BY attrition_rate_pct DESC;

-- S3 Overtime
SELECT overtime,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct
FROM hr_employee GROUP BY overtime ORDER BY attrition_rate_pct DESC;

-- S4 Business travel
SELECT business_travel,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct
FROM hr_employee GROUP BY business_travel ORDER BY attrition_rate_pct DESC;

-- S5 Age band
SELECT age_band,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee GROUP BY age_band ORDER BY MIN(age);

-- S6 Tenure band
SELECT tenure_band,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee GROUP BY tenure_band ORDER BY MIN(years_at_company);

-- S7 Job satisfaction (1 = Low ... 4 = Very High; confirm against data dictionary)
SELECT job_satisfaction,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct
FROM hr_employee GROUP BY job_satisfaction ORDER BY job_satisfaction;

-- S8 Work-life balance
SELECT work_life_balance,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct
FROM hr_employee GROUP BY work_life_balance ORDER BY work_life_balance;

-- S9 Department x role matrix (feeds the optional Power BI deep-dive page)
SELECT department, job_role,
       COUNT(*) AS employee_count,
       SUM(attrition_flag) AS leavers,
       ROUND(100.0 * SUM(attrition_flag) / NULLIF(COUNT(*), 0), 2) AS attrition_rate_pct,
       CASE WHEN COUNT(*) < 30 THEN 'small group' ELSE '' END AS flag
FROM hr_employee GROUP BY department, job_role ORDER BY department, attrition_rate_pct DESC;

-- S10 Reconciliation: segment totals must equal overall totals (expected: 0 and 0)
SELECT (SELECT COUNT(*) FROM hr_employee) - (SELECT SUM(c) FROM (SELECT COUNT(*) c FROM hr_employee GROUP BY department) d) AS dept_headcount_diff,
       (SELECT SUM(attrition_flag) FROM hr_employee) - (SELECT SUM(l) FROM (SELECT SUM(attrition_flag) l FROM hr_employee GROUP BY job_role) r) AS role_leaver_diff;
