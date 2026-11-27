-- Step 1: data-quality checks. Every query should return the "expected" value in its comment.

-- Q1 Row count (compare with python/01_clean_data.py output and the source CSV)
SELECT COUNT(*) AS total_rows FROM hr_employee;

-- Q2 Duplicate employee ids (expected: 0 rows)
SELECT employee_number, COUNT(*) FROM hr_employee GROUP BY employee_number HAVING COUNT(*) > 1;

-- Q3 Attrition coding (expected: only Yes / No)
SELECT attrition, COUNT(*) FROM hr_employee GROUP BY attrition ORDER BY attrition;

-- Q4 Null counts on key analysis fields (expected: all 0)
SELECT
    SUM(CASE WHEN department       IS NULL THEN 1 ELSE 0 END) AS null_department,
    SUM(CASE WHEN job_role         IS NULL THEN 1 ELSE 0 END) AS null_job_role,
    SUM(CASE WHEN overtime         IS NULL THEN 1 ELSE 0 END) AS null_overtime,
    SUM(CASE WHEN monthly_income   IS NULL THEN 1 ELSE 0 END) AS null_monthly_income,
    SUM(CASE WHEN years_at_company IS NULL THEN 1 ELSE 0 END) AS null_years_at_company
FROM hr_employee;

-- Q5 Numeric ranges (look for anything implausible)
SELECT MIN(age) AS min_age, MAX(age) AS max_age,
       MIN(monthly_income) AS min_income, MAX(monthly_income) AS max_income,
       MIN(years_at_company) AS min_tenure, MAX(years_at_company) AS max_tenure
FROM hr_employee;

-- Q6 Tenure longer than career length (expected: 0; otherwise document the exception)
SELECT COUNT(*) AS tenure_gt_career FROM hr_employee WHERE years_at_company > total_working_years;

-- Q7 Category values for the grouping fields
SELECT 'department' AS field, department AS value, COUNT(*) AS n FROM hr_employee GROUP BY department
UNION ALL SELECT 'overtime', overtime, COUNT(*) FROM hr_employee GROUP BY overtime
UNION ALL SELECT 'business_travel', business_travel, COUNT(*) FROM hr_employee GROUP BY business_travel
ORDER BY field, value;

-- Q8 Band coverage (expected: 0 rows labelled 'nan')
SELECT age_band, tenure_band, COUNT(*) FROM hr_employee
WHERE age_band = 'nan' OR tenure_band = 'nan' GROUP BY age_band, tenure_band;
