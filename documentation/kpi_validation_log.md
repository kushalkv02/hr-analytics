# KPI Validation Log (SQL, PostgreSQL)

Dataset: IBM HR Analytics Employee Attrition & Performance (public sample). Loaded table: `hr_employee`.

| Check | Script | Result | Expected | Status |
|---|---|---|---|---|
| Row count | 01 Q1 | 1,470 | Source CSV row count | Pass |
| Duplicate employee_number | 01 Q2 | 0 rows | 0 | Pass |
| Attrition coding | 01 Q3 | Yes 237 / No 1,233 | Yes/No only | Pass |
| Nulls on key fields | 01 Q4 | All 0 | 0 | Pass |
| Ranges | 01 Q5 | age 18-60, income 1,009-19,999, tenure 0-40 | Plausible | Pass |
| Tenure > career length | 01 Q6 | 0 | 0 | Pass |
| Category values | 01 Q7 | 3 departments, 3 travel levels, overtime Yes/No (416 Yes) | Clean labels | Pass |
| Band coverage | 01 Q8 | 0 rows | 0 | Pass |
| Active + leavers = total | 02 K4 | 0 | 0 | Pass |
| Department headcount reconciles | 03 S10 | 0 | 0 | Pass |
| Role leavers reconcile | 03 S10 | 0 | 0 | Pass |
| Overlap cells reconcile (headcount, leavers) | 04 O7 | 0 and 0 | 0 | Pass |

## Headline KPIs (three-way reconciliation)
| KPI | SQL value | Power BI | Python | Match |
|---|---|---|---|---|
| Total employees | 1,470 | 1,470 | 1,470 | Pass |
| Attrition count | 237 | 237 | 237 | Pass |
| Active employees | 1,233 | 1,233 | 1,233 | Pass |
| Attrition rate | 16.12% | 16.12% | 16.12% | Pass |
| Retention rate | 83.88% | 83.88% | 83.88% | Pass |
| Avg age / tenure / income | 36.9 / 7.01 / 6,503 | 36.9 / 7.01 / 6,503 | 36.9 / 7.01 / 6,503 | Pass |

**Result:** Power BI and Python outputs were confirmed by the analyst to match the SQL results on all headline KPIs (2026-11-27). KPI definitions are consistent across SQL, Python and Power BI.
