# Insights and Recommendations Report
**Project:** HR Analytics | Employee Attrition & Workforce Analysis
**Data:** IBM HR Analytics Employee Attrition & Performance (public sample), 1,470 employees, 237 marked Attrition = Yes
**Method:** descriptive SQL analysis (scripts 01-04), reconciled to totals; Python EDA notebook and Power BI dashboard use the same definitions

> This is a descriptive analysis of a single snapshot from a public sample. It shows where attrition is concentrated; it does not explain why any individual left, and the rates are not annualized turnover. Findings are prompts for fair investigation and employee listening, not for decisions about individuals.

---

## 1. Executive summary
- **Overall:** 237 of 1,470 employees are marked as attrited: a **16.12%** attrition rate (retention 83.88%).
- **Overtime is the largest single gap.** Employees on overtime are 28.3% of the workforce but 53.6% of leavers; their attrition rate is 30.53% versus 10.44% without overtime (about 2.9 times). The gap persists within every tenure band, age band, travel level and department checked, and in 8 of 9 job roles.
- **Early career and early tenure:** attrition is 34.88% in the first two years and 39.18% under age 25, falling to about 10% from five years' tenure and from age 35.
- **Roles:** Sales Representatives have the highest rate (39.76%); Laboratory Technicians have the most leavers (62, 26.2% of all leavers) at 23.94%.
- **Combined factors:** overtime with under 5 years' tenure and frequent travel reaches a 61.11% rate (22 of 36). Overtime with under 5 years' tenure, regardless of travel, covers 11.8% of employees and 31.6% of leavers.
- **Experience indicators:** attrition is higher at low job satisfaction (22.84% at level 1 vs 11.33% at level 4) and at work-life balance level 1 (31.25%, n=80).

## 2. Evidence by finding
Each finding follows: observation, evidence, interpretation, action, measurement.

### F1. Overtime coincides with much higher attrition
- **Observation:** attrition is higher among employees recorded as working overtime.
- **Evidence:**

| Overtime | Employees | Leavers | Rate | Share of leavers |
|---|---|---|---|---|
| Yes | 416 | 127 | 30.53% | 53.59% |
| No | 1,054 | 110 | 10.44% | 46.41% |

Within-slice checks (rate with overtime vs without): tenure 0-1 yrs 55.07% vs 25.34%; 2-4 yrs 35.24% vs 11.15%; 5-9 yrs 24.14% vs 6.07%; 10+ yrs 17.53% vs 7.81%; R&D 27.31% vs 8.55%; Sales 37.50% vs 13.84%; Laboratory Technician 50.00% vs 15.74%; Research Scientist 34.02% vs 7.18%; Sales Executive 32.98% vs 11.21%. The only role with no gap is Healthcare Representative (5.41% vs 7.45%, 37 on overtime).
- **Interpretation:** overtime is not simply a by-product of one role, tenure or age group in this sample. It may reflect workload, staffing levels, scheduling or role design, but this snapshot cannot establish why, and unmeasured factors cannot be ruled out.
- **Action:** review workload and overtime patterns in the teams with the most overtime-related leavers (Laboratory Technician, Research Scientist, Sales Executive); run listening sessions on workload and scheduling; consider a pilot (for example workload planning or staffing review in one department).
- **Measurement:** cohort-level attrition and the overtime share by team on dated snapshots (quarterly), compared with comparable teams not in the pilot.

### F2. The first two years carry the highest attrition
- **Observation:** attrition falls steeply with tenure.
- **Evidence:**

| Tenure band | Employees | Leavers | Rate |
|---|---|---|---|
| 0-1 yrs | 215 | 75 | 34.88% |
| 2-4 yrs | 365 | 66 | 18.08% |
| 5-9 yrs | 524 | 58 | 11.07% |
| 10+ yrs | 366 | 38 | 10.38% |

Employees with under 5 years' tenure are 39.5% of the workforce and 59.5% of leavers (141 of 237).
- **Interpretation:** early-tenure employees are over-represented among leavers. Onboarding, role expectations, early development and manager support are reasonable areas to look at; the data cannot say which matters.
- **Action:** review onboarding and early-career experience; add structured check-ins at set points in the first year (for example 3, 6 and 12 months) and summarise themes at team level.
- **Measurement:** first-year and second-year cohort attrition from dated snapshots; check-in participation and aggregated themes.

### F3. Role patterns: highest rate vs largest headcount
- **Evidence:**

| Role | Employees | Leavers | Rate | Share of leavers |
|---|---|---|---|---|
| Sales Representative | 83 | 33 | 39.76% | 13.92% |
| Laboratory Technician | 259 | 62 | 23.94% | 26.16% |
| Human Resources | 52 | 12 | 23.08% | 5.06% |
| Sales Executive | 326 | 57 | 17.48% | 24.05% |
| Research Scientist | 292 | 47 | 16.10% | 19.83% |
| Manufacturing Director | 145 | 10 | 6.90% | 4.22% |
| Healthcare Representative | 131 | 9 | 6.87% | 3.80% |
| Manager | 102 | 5 | 4.90% | 2.11% |
| Research Director | 80 | 2 | 2.50% | 0.84% |

The four roles Sales Representative, Laboratory Technician, Sales Executive and Research Scientist account for 199 of 237 leavers (84.0%) and 65.3% of employees. By department: Sales 20.63% (92 leavers), Human Resources 19.05% (12 leavers, n=63), R&D 13.84% (133 leavers, 56.1% of leavers).
- **Interpretation:** prioritise by both rate and headcount. Sales Representative has the highest rate but a smaller headcount (and only 24 on overtime); Laboratory Technician combines a high rate with the largest number of leavers. Human Resources roles are a small group, so the rate is less stable.
- **Action:** HRBPs for Sales and R&D review role expectations, workload, targets and development paths for these four roles, starting with Laboratory Technician and Sales Representative.
- **Measurement:** attrition rate and leaver count per role on dated snapshots, with n shown; roles under 30 employees reported with a caution.

### F4. Business travel adds to the pattern
- **Evidence:** Travel_Frequently 24.91% (277 employees, 69 leavers), Travel_Rarely 14.96% (1,043; 156), Non-Travel 8.00% (150; 12). Overtime and travel appear additive: with overtime, frequent travel is 41.86% (n=86) vs 28.47% for rare travel (n=295); without overtime, 17.28% (n=191) vs 9.63% (n=748).
- **Interpretation:** frequent travel coincides with higher attrition both with and without overtime; it may reflect recovery time, family or workload pressure, but the data cannot say.
- **Action:** review travel expectations and recovery time for roles with frequent travel; include travel in listening sessions.
- **Measurement:** attrition rate for frequent travelers on dated snapshots.

### F5. Work-life balance and job satisfaction indicators
- **Evidence:**

| Job satisfaction | Employees | Leavers | Rate |
|---|---|---|---|
| 1 | 289 | 66 | 22.84% |
| 2 | 280 | 46 | 16.43% |
| 3 | 442 | 73 | 16.52% |
| 4 | 459 | 52 | 11.33% |

Work-life balance: level 1 31.25% (n=80), level 2 16.86% (344), level 3 14.22% (893), level 4 17.65% (153).
- **Interpretation:** low scores coincide with higher attrition, but the pattern is not a smooth trend (satisfaction 2 and 3 are nearly equal; work-life balance 4 is above 3), and work-life balance level 1 is a small group. Treat these as directional.
- **Action:** use a short pulse survey and team-level conversations to find what drives low scores, rather than targeting individuals.
- **Measurement:** distribution of scores by team over time; attrition by score level.

### F6. Leavers differ on age, tenure and income, which move together
- **Evidence (averages):**

| | Employees | Age | Tenure (yrs) | Monthly income | Job satisfaction |
|---|---|---|---|---|---|
| Stayed (No) | 1,233 | 37.6 | 7.37 | 6,833 | 2.78 |
| Left (Yes) | 237 | 33.6 | 5.13 | 4,787 | 2.47 |

By age band: <25 39.18% (97 employees), 25-34 20.22% (554), 35-44 10.10% (505), 45-54 10.20% (245), 55+ 15.94% (69). People under 35 are 44.3% of employees and 63.3% of leavers.
- **Interpretation:** age, tenure and income are closely related and also related to role and level, so this snapshot cannot say whether pay, career stage or role drives the gap. Age is described only to understand career stage; it must not be used to justify employment decisions.
- **Action:** compare pay within the same role and level internally before drawing conclusions (external benchmarking is out of scope); focus any action on work conditions and development, not on age groups.
- **Measurement:** within-role pay distributions for leavers vs stayers on dated snapshots.

## 3. Where to investigate first
| Priority | Segment | Employees | Leavers | Rate | Why |
|---|---|---|---|---|---|
| 1 | Overtime = Yes | 416 | 127 | 30.53% | Largest gap; over half of leavers |
| 2 | Laboratory Technician | 259 | 62 | 23.94% | Most leavers of any role; 50.00% with overtime |
| 3 | Tenure 0-1 yrs | 215 | 75 | 34.88% | Highest tenure-band rate |
| 4 | Sales Representative | 83 | 33 | 39.76% | Highest role rate (smaller group) |
| 5 | Sales Executive / Research Scientist | 326 / 292 | 57 / 47 | 17.48% / 16.10% | Large headcount; strong overtime gap |
| 6 | Overtime + under 5 yrs + frequent travel | 36 | 22 | 61.11% | Highest combined rate (small group) |

## 4. Recommended actions (consolidated)
1. **Workload and overtime review** in Laboratory Technician, Research Scientist and Sales Executive teams; pilot in one department.
2. **Early-career programme review:** onboarding, role expectations and check-ins across the first two years, starting with Laboratory Technician and Sales Representative.
3. **Sales Representative role review:** expectations, targets and development, with the caution that the group is small.
4. **Travel review** for frequently traveling roles, especially when combined with overtime.
5. **Pulse survey and team listening** on satisfaction and work-life balance, reported at team level only.
6. **Measurement plan:** capture dated snapshots (at least quarterly), report cohort-level attrition with counts, keep a minimum group size, and re-run this analysis on the new data.

## 5. Limitations and ethics
- Public sample dataset; may not represent any organization.
- Single snapshot with a historical flag: no time trend and no annualized turnover.
- Associations only; one-variable splits are not statistically adjusted, and unmeasured factors may matter.
- Small groups (for example Human Resources roles, work-life balance level 1, overtime within Sales Representative) give unstable rates.
- Age, gender and marital status can proxy sensitive characteristics: aggregate use only, never to justify adverse employment decisions, and no employee-level scoring or ranking.
- Recommendations are investigation and pilot ideas for HR to test, not conclusions about causes.

## 6. Reproducibility
Numbers come from `sql/01-04` run on the loaded 1,470-row table; reconciliation checks returned 0 differences (`kpi_validation_log.md`). The Python notebook (`python/hr_attrition_eda.ipynb`) and Power BI measures use identical definitions and should reproduce these figures.
