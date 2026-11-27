-- Step 2: headline KPIs (definitions in README / KPI dictionary).
-- Attrition rate = leavers / total employees. Snapshot measure, NOT annualized turnover.

-- K1 Overall KPIs
SELECT
    COUNT(*)                                                         AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)               AS leavers,
    SUM(CASE WHEN attrition = 'No'  THEN 1 ELSE 0 END)               AS active_employees,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*), 0), 2)                                  AS attrition_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'No' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*), 0), 2)                                  AS retention_rate_pct
FROM hr_employee;

-- K2 Descriptive averages
SELECT ROUND(AVG(age), 1)              AS avg_age,
       ROUND(AVG(years_at_company), 2) AS avg_tenure_years,
       ROUND(AVG(monthly_income), 0)   AS avg_monthly_income
FROM hr_employee;

-- K3 Leavers vs non-leavers
SELECT attrition,
       COUNT(*)                        AS employees,
       ROUND(AVG(age), 1)              AS avg_age,
       ROUND(AVG(years_at_company), 2) AS avg_tenure_years,
       ROUND(AVG(monthly_income), 0)   AS avg_monthly_income,
       ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM hr_employee
GROUP BY attrition
ORDER BY attrition;

-- K4 Reconciliation: active + leavers must equal total (expected: difference = 0)
SELECT COUNT(*) - SUM(CASE WHEN attrition IN ('Yes','No') THEN 1 ELSE 0 END) AS difference
FROM hr_employee;
