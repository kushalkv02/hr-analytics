# Data Quality Summary
_Generated 2026-11-27 by python/01_clean_data.py_

## 1. Structure
- Source file: `WA_Fn-UseC_-HR-Employee-Attrition.csv`
- Rows: 1,470  |  Columns: 35

## 2. Nulls and duplicates
- Columns with nulls: 0
- Fully duplicated rows: 0
- Duplicate employee_number values: 0

## 3. Attrition field
attrition
No     1233
Yes     237

## 4. Categorical values
- `attrition` (2): No, Yes
- `business_travel` (3): Non-Travel, Travel_Frequently, Travel_Rarely
- `department` (3): Human Resources, Research & Development, Sales
- `education_field` (6): Human Resources, Life Sciences, Marketing, Medical, Other, Technical Degree
- `gender` (2): Female, Male
- `job_role` (9): Healthcare Representative, Human Resources, Laboratory Technician, Manager, Manufacturing Director, Research Director, Research Scientist, Sales Executive, Sales Representative
- `marital_status` (3): Divorced, Married, Single
- `over18` (1): Y
- `overtime` (2): No, Yes

## 5. Range checks
- age: 18-60
- monthly_income: 1,009-19,999
- years_at_company: 0-40
- Rows where years_at_company > total_working_years: 0

## 6. Constant columns dropped
- `employee_count` = 1 for all rows -> dropped
- `over18` = 'Y' for all rows -> dropped
- `standard_hours` = 80 for all rows -> dropped

## 7. Derived fields
- `age_band` boundaries: <25, 25-34, 35-44, 45-54, 55+
- `tenure_band` (years at company): 0-1, 2-4, 5-9, 10+
- `attrition_flag`: 1 = Yes, 0 = No

## 8. Headline numbers (use to reconcile SQL and Power BI)
- Total employees: 1,470
- Leavers (Attrition = Yes): 237
- Active (Attrition = No): 1,233
- Attrition rate: 16.12%
