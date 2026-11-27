# HR Analytics | Employee Attrition & Workforce Analysis

Descriptive decision-support project: where is attrition concentrated, and which segments should HR investigate first?
Tools: Python (pandas), PostgreSQL, Power BI. Dataset: IBM HR Analytics public sample.

> Descriptive analysis only. Associations here do not establish why any individual leaves. Aggregate reporting only.

## Key findings (SQL, descriptive; 1,470 employees, 237 leavers)
Overall attrition rate is **16.12%** (237 of 1,470); retention 83.88%. This is a snapshot share, not annualized turnover.

| Segment | Employees | Leavers | Attrition rate | Share of all leavers |
|---|---|---|---|---|
| Sales (dept) | 446 | 92 | 20.63% | 38.82% |
| R&D (dept) | 961 | 133 | 13.84% | 56.12% |
| Human Resources (dept) | 63 | 12 | 19.05% | 5.06% |
| Sales Representative (role) | 83 | 33 | 39.76% | 13.92% |
| Laboratory Technician (role) | 259 | 62 | 23.94% | 26.16% |
| Overtime = Yes | 416 | 127 | 30.53% | 53.59% |
| Overtime = No | 1,054 | 110 | 10.44% | 46.41% |
| Travel_Frequently | 277 | 69 | 24.91% | |
| Non-Travel | 150 | 12 | 8.00% | |
| Age <25 | 97 | 38 | 39.18% | |
| Tenure 0-1 years | 215 | 75 | 34.88% | |
| Work-life balance = 1 | 80 | 25 | 31.25% | |
| Job satisfaction = 1 | 289 | 66 | 22.84% | |

- **Rate vs headcount:** Sales Representatives have the highest rate (39.76%) but Laboratory Technicians account for the most leavers of any role (62, 26.16%). Both merit attention for different reasons.
- **Overtime:** employees working overtime are 28.3% of the workforce but 53.6% of leavers, with an attrition rate about 2.9 times that of those who do not (30.53% vs 10.44%). It is the largest single gap in this sample, but it is an association and does not show that overtime causes exits.
- **Early career and early tenure:** attrition is highest under age 25 and in the first two years, and falls to about 10% from age 35 and from five years' tenure.
- **Leavers vs non-leavers (averages):** age 33.6 vs 37.6, tenure 5.13 vs 7.37 years, monthly income 4,787 vs 6,833, job satisfaction 2.47 vs 2.78.
- **Not a clean trend:** work-life balance level 4 (17.65%, n=153) is above level 3 (14.22%), and age 55+ (15.94%, n=69) rises from the 45-54 band; the smaller groups are less stable.
- These are associations in a public sample; they do not explain why any individual left.

### Overlap analysis: does overtime stand on its own?
Overtime keeps a higher attrition rate within every slice checked (one variable at a time, not statistically adjusted):

| Slice | Overtime Yes | Overtime No |
|---|---|---|
| Tenure 0-1 yrs | 55.07% (n=69) | 25.34% (n=146) |
| Tenure 2-4 yrs | 35.24% (n=105) | 11.15% (n=260) |
| Tenure 5-9 yrs | 24.14% (n=145) | 6.07% (n=379) |
| Tenure 10+ yrs | 17.53% (n=97) | 7.81% (n=269) |
| Age <25 | 67.74% (n=31) | 25.76% (n=66) |
| Age 35-44 | 20.53% (n=151) | 5.65% (n=354) |
| Frequent travel | 41.86% (n=86) | 17.28% (n=191) |
| Non-Travel | 20.00% (n=35) | 4.35% (n=115) |
| R&D | 27.31% (n=271) | 8.55% (n=690) |
| Sales | 37.50% (n=128) | 13.84% (n=318) |

- **By role:** the overtime gap is positive in 8 of 9 roles. The larger gaps among bigger groups are Laboratory Technician (50.00% vs 15.74%, +34.3 pp), Research Scientist (34.02% vs 7.18%) and Sales Executive (32.98% vs 11.21%). Healthcare Representative is the exception (5.41% vs 7.45%, 37 on overtime). Sales Representative shows the biggest gap (+37.9 pp) but only 24 employees are on overtime, so treat it as indicative.
- **Combined groups:** employees on overtime with under 5 years' tenure and frequent travel have a 61.11% attrition rate (22 of 36; 2.45% of employees, 9.28% of leavers). Overtime with under 5 years' tenure, regardless of travel, covers 174 employees (11.8%) and 75 leavers (31.6%). The lowest-rate group is no overtime, 5+ years, other travel: 6.04% (32 of 530).
- **Overtime and travel look additive:** within overtime, frequent travel raises the rate again (41.86% vs 28.47% for rare travel), and overtime raises it within every travel level.
- **Reading this carefully:** the persistence of the overtime gap shows it is not simply a side effect of one role, tenure, age or travel group in this sample. It does not rule out other unmeasured factors and does not show causation.

## How to reproduce
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r python/requirements.txt
# place the CSV in data/raw/ (see data/README.md)
python python/01_clean_data.py
```
Then in PostgreSQL run, in order: `sql/00_create_table.sql` (load the processed CSV), `01_data_quality_checks.sql`, `02_kpi_calculations.sql`, `03_attrition_segmentation.sql`, `04_overlap_analysis.sql`.

## Structure
```
data/            raw + processed CSVs (git-ignored) and source notes
sql/             schema, quality checks, KPIs, segmentation, overlap analysis
python/          cleaning/profiling script, EDA notebook
powerbi/         dashboard .pbix (next)
documentation/   requirements (BRD), data and KPI dictionaries, KPI validation log, Power BI build guide, insights and recommendations, auto-generated data-quality summary
images/          dashboard screenshots
```

## Limitations
Public sample, static snapshot (no time series), small segments give unstable rates, some fields proxy sensitive characteristics.
