# Power BI Build Guide | HR Attrition Dashboard

Goal: an interactive, aggregate-only dashboard that shows attrition **rates with their denominators**, passes the UAT in the requirements document, and reconciles to the SQL results.

Power BI Desktop runs on Windows only. If the machine you build on has no PostgreSQL, that is fine: import the cleaned CSV, and use the SQL results already recorded in `kpi_validation_log.md` as your reconciliation targets.

**Take with you:** `data/processed/hr_employee_clean.csv`, this guide, `kpi_validation_log.md`. **Bring back:** `powerbi/hr_attrition_dashboard.pbix`, screenshots for `images/`.

---

## 1. Load the data

1. Home > Get data > Text/CSV > `hr_employee_clean.csv` > **Transform Data**.
2. In Power Query confirm types: text for `attrition, business_travel, department, education_field, gender, job_role, marital_status, overtime, age_band, tenure_band`; whole number for everything else (including the 1-4 scale fields and `attrition_flag`).
3. Do not edit values. Rename the query/table to **HR_Employee**.
4. Add a refresh-date table: Home > New source > Blank query > Advanced editor, then paste:
   ```
   let
       Source = #table(type table [LastRefresh = datetime], {{DateTime.LocalNow()}})
   in
       Source
   ```
   Name it **Refresh_Info**.
5. Close & Apply.

## 2. Model

A single table is enough; do not create relationships that could duplicate employee rows.

**Hide from report view** (right-click > Hide in report view): `employee_number` (identifier, BR-06), `attrition_flag`, `daily_rate, hourly_rate, monthly_rate` (unclear meaning in the source), and the order helpers below.

### Calculated columns (Table tools > New column)
```
Age Band Order =
SWITCH ( HR_Employee[age_band], "<25", 1, "25-34", 2, "35-44", 3, "45-54", 4, "55+", 5 )

Tenure Band Order =
SWITCH ( HR_Employee[tenure_band], "0-1", 1, "2-4", 2, "5-9", 3, "10+", 4 )

Job Satisfaction Label =
SWITCH ( HR_Employee[job_satisfaction], 1, "1 Low", 2, "2 Medium", 3, "3 High", 4, "4 Very High" )

Work-Life Balance Label =
SWITCH ( HR_Employee[work_life_balance], 1, "1 Bad", 2, "2 Good", 3, "3 Better", 4, "4 Best" )
```
(The scale wording follows the usual IBM dataset documentation; verify against your copy.)

**Sort by column** (select the column > Column tools > Sort by column): `age_band` by Age Band Order; `tenure_band` by Tenure Band Order. The two label columns already sort correctly because of their number prefix.

## 3. Measures
Create a blank table (Enter data, one empty column, name it **_Measures**), then add:

```
Total Employees = COUNTROWS ( HR_Employee )

Attrition Count =
CALCULATE ( COUNTROWS ( HR_Employee ), HR_Employee[attrition] = "Yes" )

Active Employees =
CALCULATE ( COUNTROWS ( HR_Employee ), HR_Employee[attrition] = "No" )

Attrition Rate = DIVIDE ( [Attrition Count], [Total Employees], 0 )

Retention Rate = DIVIDE ( [Active Employees], [Total Employees], 0 )

Average Age = AVERAGE ( HR_Employee[age] )
Average Tenure = AVERAGE ( HR_Employee[years_at_company] )
Average Monthly Income = AVERAGE ( HR_Employee[monthly_income] )

Overall Attrition Rate =
CALCULATE ( [Attrition Rate], ALL ( HR_Employee ) )

Rate vs Overall (pp) =
( [Attrition Rate] - [Overall Attrition Rate] ) * 100

Share of Leavers =
DIVIDE ( [Attrition Count], CALCULATE ( [Attrition Count], ALLSELECTED ( HR_Employee ) ), 0 )

Small Group Flag =
IF ( [Total Employees] < 30, "Small group (n<30)", "" )

Rate Label =
FORMAT ( [Attrition Rate], "0.0%" ) & " (n=" & [Total Employees] & ")"

Attrition Rate OT Yes =
CALCULATE ( [Attrition Rate], HR_Employee[overtime] = "Yes" )

Attrition Rate OT No =
CALCULATE ( [Attrition Rate], HR_Employee[overtime] = "No" )

Overtime Gap (pp) =
( [Attrition Rate OT Yes] - [Attrition Rate OT No] ) * 100

Avg Income Leavers =
CALCULATE ( [Average Monthly Income], HR_Employee[attrition] = "Yes" )

Avg Income Stayers =
CALCULATE ( [Average Monthly Income], HR_Employee[attrition] = "No" )

Last Refreshed =
"Data refreshed: " & FORMAT ( MAX ( Refresh_Info[LastRefresh] ), "dd mmm yyyy" )
```

**Formats** (Measure tools): Attrition Rate, Retention Rate, Overall Attrition Rate, Share of Leavers, OT rates = Percentage, 1 decimal; Rate vs Overall (pp) and Overtime Gap (pp) = Decimal, 1 place; Average Monthly Income = Whole number with thousands separator; Average Age/Tenure = 1-2 decimals.

Note: `Share of Leavers` uses ALLSELECTED so it stays a share of the currently filtered leavers. The two OT measures override any overtime slicer on purpose.

## 4. Theme and design rules
- Canvas 16:9. One font (Segoe UI). Titles state the metric and unit, e.g. "Attrition rate (%) by department".
- Colors: **Yes / leavers = #E45756**, **No / stayers = #4C78A8**, neutral grey #9AA0A6, reference line = overall rate. Use these everywhere.
- No 3D, no dense pie charts. A donut with two slices (Yes/No) is acceptable for the status split.
- Every rate visual shows the headcount: put `Total Employees` and `Attrition Count` in the tooltip, or use `Rate Label` as the data label.
- Flag small groups: conditional formatting (grey bar/text) when `Total Employees` < 30, and show `Small Group Flag` in tables and tooltips.
- Percent axes start at 0.

## 5. Pages

### Page 1: Workforce Overview
```
+------------------------------------------------------------------+
| Title: HR Attrition Overview     Last Refreshed   [Reset filters] |
+----------+----------+----------+----------+----------------------+
| Total    | Attrition| Attrition| Retention|  Slicers:            |
| Employees| Count    | Rate     | Rate     |  Department          |
|          |          |          |          |  Job role            |
+----------+----------+----------+----------+  Gender              |
| Attrition rate by department  | Leavers   |  Overtime            |
| (bar, sorted desc, rate label)| by job    |                      |
|                               | role (bar)|                      |
+-------------------------------+-----------+----------------------+
| Attrition status split (Yes/No donut) | Definitions text box     |
+------------------------------------------------------------------+
```
- KPI cards: the four measures. Add `Average Age`, `Average Tenure`, `Average Monthly Income` as small secondary cards if space allows.
- Department bar: axis `department`, value `Attrition Rate`, data label `Rate Label` (or rate + tooltip with counts), sort by rate desc, reference line at `Overall Attrition Rate`.
- Role bar: axis `job_role`, value `Attrition Count` (the doc asks for counts by role); tooltip adds `Attrition Rate`, `Total Employees`, `Small Group Flag`.
- Definitions text box: KPI definitions, "Snapshot of a public sample dataset; not annualized turnover", dataset source/version, and the `Last Refreshed` measure (BR-05).

### Page 2: Attrition Drivers and Segments
- Clustered bar: `overtime` and `business_travel` (two visuals) by `Attrition Rate`, tooltips with counts.
- Column charts: `age_band`, `tenure_band` (sorted by order columns) by `Attrition Rate`.
- Bars: `Job Satisfaction Label`, `Work-Life Balance Label` by `Attrition Rate` (WLB level 1 has only 80 employees; keep the tooltip visible).
- Leavers vs stayers: clustered bar, axis `attrition`, values `Average Monthly Income` and `Average Tenure` (use two small visuals if scales clash).
- Heatmap matrix: rows `tenure_band`, columns `overtime`, values `Attrition Rate`, background color = gradient (white to #4C78A8); add `Total Employees` as a second value or tooltip.
- Same slicers as Page 1 (sync via View > Sync slicers).

### Page 3: Department and Role Deep Dive (optional)
- Matrix: rows `department` > `job_role`; values `Total Employees`, `Attrition Count`, `Attrition Rate`, `Share of Leavers`, `Small Group Flag`. Sort by `Attrition Rate`. Data bars on `Attrition Count`.
- Drill-through: create page **Department Detail** with drill-through field `department`; contents: KPI cards, role bar, tenure band column.
- Text box with 2-3 interpretation notes, phrased as associations.

### Tooltip page (recommended)
Page size Tooltip; visuals: `Total Employees`, `Attrition Count`, `Attrition Rate`, `Rate vs Overall (pp)`, `Small Group Flag`. Assign it as the report-page tooltip on rate visuals.

## 6. Interactions
1. **Slicers:** department, job role, gender, overtime, business travel; add age band and tenure band on Page 2. Do not add `employee_number` or any employee-level table.
2. **Cross-filtering:** keep default; for the KPI cards use Format > Edit interactions so bars do not filter the cards unexpectedly if you prefer fixed headline cards (decide and document).
3. **Reset filters:** set all slicers to nothing selected, View > Bookmarks > Add > name "Reset" (keep Data and Display ticked), then Insert > Buttons > Bookmark > choose "Reset". Place it on every page.
4. **Drill-through** as in Page 3.

## 7. Validate before you screenshot
Use these SQL values (from `kpi_validation_log.md` and the findings). With no slicer selected, the cards must read:

| Measure | Expected |
|---|---|
| Total Employees | 1,470 |
| Attrition Count | 237 |
| Active Employees | 1,233 |
| Attrition Rate | 16.12% |
| Retention Rate | 83.88% |
| Average Age / Tenure / Income | 36.9 / 7.01 / 6,503 |

Then test these selections:

| Slicer selection | Employees | Leavers | Rate |
|---|---|---|---|
| Department = Sales | 446 | 92 | 20.63% |
| Department = Research & Development | 961 | 133 | 13.84% |
| Department = Human Resources | 63 | 12 | 19.05% |
| Overtime = Yes | 416 | 127 | 30.53% |
| Overtime = No | 1,054 | 110 | 10.44% |
| Job role = Sales Representative | 83 | 33 | 39.76% |
| Tenure band = 0-1 | 215 | 75 | 34.88% |
| Age band = <25 | 97 | 38 | 39.18% |
| Business travel = Travel_Frequently | 277 | 69 | 24.91% |
| Overtime = Yes and Tenure band = 0-1 | 69 | 38 | 55.07% |

Click Reset: the full-population view must return (UAT-05). Record results in the UAT section of `kpi_validation_log.md` (fill the Power BI column) and keep screenshots.

## 8. Finish
- File > Save as `hr_attrition_dashboard.pbix` into `powerbi/`.
- Export page screenshots to `images/` (e.g. `dashboard_overview.png`, `dashboard_drivers.png`) and add them to the README.
- Optionally File > Export > PDF for the portfolio. Publish to the web only after checking the dataset terms; the data is a public sample with no real employees.

## 9. Troubleshooting
| Symptom | Fix |
|---|---|
| Age/tenure bands sort alphabetically | Set Sort by column to the order helper (section 2) |
| Rate shows 0.16 not 16.1% | Format the measure as Percentage |
| Cards ignore a slicer | Check Edit interactions; never use ALL inside the base measures |
| Rate is blank for a segment | `DIVIDE` returns 0 for empty segments by design; check filters |
| Totals do not match SQL | Re-import the CSV; confirm 1,470 rows and no extra Power Query filters |
