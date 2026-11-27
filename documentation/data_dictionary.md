# Data Dictionary

Column names are snake_case after cleaning. Coded-scale meanings below follow the public IBM dataset's usual documentation; **verify against your downloaded copy** before publishing.

| Field | Type | Group | Notes |
|---|---|---|---|
| age | int | Profile | Source for `age_band` |
| attrition | Yes/No | Outcome | Leaver flag; `attrition_flag` = 1 for Yes |
| business_travel | text | Organization | Non-Travel / Travel_Rarely / Travel_Frequently |
| daily_rate, hourly_rate, monthly_rate | int | Compensation | Rate fields; meaning is unclear in the source, avoid headline use |
| department | text | Organization | |
| distance_from_home | int | Work conditions | |
| education | 1-5 | Profile | Coded scale |
| education_field | text | Profile | |
| employee_number | int | Identifier | Unique id; **exclude from public visuals** |
| environment_satisfaction, job_satisfaction, relationship_satisfaction | 1-4 | Engagement | 1 = Low ... 4 = Very High |
| gender, marital_status | text | Profile | Sensitive proxies; aggregate use only |
| job_involvement | 1-4 | Work conditions | |
| job_level | 1-5 | Organization | |
| job_role | text | Organization | |
| monthly_income | int | Compensation | Source for descriptive comparisons |
| num_companies_worked | int | History | |
| overtime | Yes/No | Work conditions | Renamed from OverTime |
| percent_salary_hike | int | Compensation | |
| performance_rating | int | Performance | |
| stock_option_level | 0-3 | Compensation | |
| total_working_years | int | History | |
| training_times_last_year | int | Development | |
| work_life_balance | 1-4 | Work conditions | 1 = Bad ... 4 = Best |
| years_at_company, years_in_current_role, years_since_last_promotion, years_with_curr_manager | int | History | Tenure fields |

## Derived fields
| Field | Definition |
|---|---|
| attrition_flag | 1 if attrition = 'Yes', else 0 |
| age_band | <25, 25-34, 35-44, 45-54, 55+ (lower bound inclusive) |
| tenure_band | years_at_company: 0-1, 2-4, 5-9, 10+ (lower bound inclusive) |

## Dropped (constant) columns
`employee_count`, `over18`, `standard_hours` carry one value for every row; the cleaning script verifies this before dropping them.
