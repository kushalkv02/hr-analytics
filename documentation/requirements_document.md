# Business Requirements Document
**Project:** HR Analytics | Employee Attrition & Workforce Analysis
**Document type:** Business Requirements Document (BRD) with functional requirements, acceptance criteria and UAT
**Status:** Draft v1.0 | **Data source:** IBM HR Analytics Employee Attrition & Performance (public sample) | **Type:** Portfolio project, not a real organization

---

## 1. Purpose
Define what the HR attrition analytics solution must deliver, for whom, and how it will be accepted. The solution is a descriptive decision-support tool: it shows where attrition is concentrated and how the workforce looks in those segments. It does not predict individual exits or explain individual decisions.

## 2. Business problem and opportunity
Employee exits create recruitment, onboarding, training, productivity and continuity costs. HR teams need a consistent way to compare attrition across workforce segments instead of relying on static totals.

**Problem statement:** HR leadership needs an interactive view of attrition and workforce composition to identify where attrition is elevated, understand the characteristics of affected groups, and guide targeted retention initiatives.

**Opportunity:** a single, validated view with shared metric definitions lets HR prioritise investigation by both rate and headcount, and monitor change over time once dated snapshots exist.

## 3. Objectives and success measures
| # | Objective | Success measure |
|---|---|---|
| O1 | Audit and prepare the dataset | Data-quality checks documented; exceptions explained |
| O2 | Define KPIs with explicit numerators, denominators and filter behavior | KPI dictionary approved; same definitions in SQL, Python and Power BI |
| O3 | Quantify workforce and attrition patterns | Segment rates with counts for department, role, overtime, travel, age, tenure, satisfaction |
| O4 | Deliver an interactive dashboard | Passes UAT-01 to UAT-07 |
| O5 | Turn findings into qualified recommendations | Insights report uses validated numbers and avoids causal claims |

## 4. Scope
**In scope:** workforce headcount and attrition summary; comparisons by department, role, tenure, age, overtime, travel and satisfaction; data-quality checks, KPI reconciliation, dashboard filters and UAT; descriptive analysis and stakeholder recommendations.

**Out of scope:** automated employee-level risk scoring or employment decisions; causal claims about why an individual leaves; live HRIS/payroll integration or external pay benchmarking; recommendations about specific employees.

## 5. Stakeholders
| Stakeholder | Needs | Use |
|---|---|---|
| HR Director | Overall attrition, priority areas | Retention initiatives, workforce planning |
| HR Business Partners | Department and role breakdowns | Investigate team-level patterns |
| Talent / Recruitment | Replacement demand by role | Hiring capacity and pipeline planning |
| Department Managers | Relevant team insights | Review workload, support, development |
| Business Leadership | Concise KPIs and implications | Resource allocation and monitoring |

## 6. Business requirements
| ID | Requirement | Priority |
|---|---|---|
| BR-01 | Show workforce and attrition metrics in a summary view | Must |
| BR-02 | Filter by department, role and relevant employee attributes | Must |
| BR-03 | Compare attrition across meaningful segments | Must |
| BR-04 | Show population counts and denominators alongside rates | Must |
| BR-05 | Display metric definitions, dataset period and refresh date | Must |
| BR-06 | Avoid unnecessary exposure of employee-level information | Must |

## 7. Functional requirements
| ID | Requirement | Traces to |
|---|---|---|
| FR-01 | Load and transform source data into an analysis-ready table (snake_case names, derived age/tenure bands, attrition flag) | BR-01 |
| FR-02 | Calculate total employees, leavers, active employees, attrition rate, retention rate | BR-01 |
| FR-03 | Display attrition by department, role, tenure, age, overtime, travel and satisfaction | BR-03 |
| FR-04 | Support cross-filtering and drill-through; provide a reset-filters control | BR-02 |
| FR-05 | Reconcile dashboard totals to independent SQL/Python calculations | BR-01, BR-04 |
| FR-06 | Show employee count (denominator) with every rate; flag segments under 30 employees | BR-04 |
| FR-07 | Show KPI definitions, dataset source/version and refresh date on the dashboard | BR-05 |
| FR-08 | Exclude employee identifiers from all visuals; no employee-level tables | BR-06 |

## 8. Data requirements
- **Source:** IBM HR Analytics public sample, one row per employee (commonly 1,470 rows, 35 columns); confirm version and row count on download.
- **Outcome field:** `Attrition` (Yes/No), a historical leaver flag in a single snapshot.
- **Field groups:** profile, organization, employment history, work conditions, compensation, engagement (see `data_dictionary.md`).
- **Preparation rules:** keep an untouched raw copy; check row count, duplicate IDs, nulls, categories and ranges; document band boundaries (age: <25, 25-34, 35-44, 45-54, 55+; tenure: 0-1, 2-4, 5-9, 10+).
- **Known limitations:** static public sample; may not represent any organization; no time dimension.

## 9. KPI definitions (summary)
Attrition Rate = leavers / total employees. Retention Rate = active / total employees. Segment attrition rate = leavers in the segment / employees in the segment (never divided by all leavers). Not an annualized or monthly turnover rate. Full list in `kpi_dictionary.md`.

## 10. Non-functional and governance requirements
| ID | Requirement |
|---|---|
| NFR-01 | Aggregate reporting only; no employee-level ranking or profiling |
| NFR-02 | Demographic patterns must not be used to justify adverse employment decisions |
| NFR-03 | Apply a minimum group size of 30 for flagging unstable rates |
| NFR-04 | Metric definitions identical across SQL, Python and Power BI |
| NFR-05 | Raw and processed data not committed to the public repository |
| NFR-06 | Every finding states population, comparison group, rate and count, and avoids causal wording |

## 11. Assumptions and constraints
- Each row is one distinct employee in a single snapshot.
- Attrition is consistently coded Yes/No.
- All KPIs use the same population and filter context unless stated.
- Power BI Desktop is Windows-only; the dashboard can be built from the cleaned CSV.

## 12. Risks
| Risk | Mitigation |
|---|---|
| Public sample may not reflect a real workforce | State this on the dashboard and in the README |
| Small groups give unstable rates | Show counts; flag n < 30; qualify conclusions |
| Some attributes proxy sensitive characteristics | Aggregate use only; actions target work conditions, not demographics |
| Associations misread as causes | Interpretation wording rules (NFR-06); limitations section in the insights report |
| Metric drift between tools | Reconciliation log and UAT |

## 13. User stories and acceptance criteria
| User story | Acceptance criteria |
|---|---|
| As an HR leader, I want attrition at a glance | KPI cards show workforce size, leavers, rate and retention; values reconcile to SQL |
| As an HRBP, I want department comparisons | Visual shows headcount, leaver count and rate; filters work |
| As a manager, I want role patterns | Role comparisons are sortable and show denominator context |
| As a report user, I want to filter the workforce | Slicers cross-filter relevant visuals; reset option available |
| As a reviewer, I want trustworthy metrics | Definitions, refresh date, assumptions and validation checks documented |

## 14. UAT
Expected values come from the validated SQL results (1,470 employees, 237 leavers).

| ID | Scenario | Expected result | Actual | Status |
|---|---|---|---|---|
| UAT-01 | Compare employee KPI with source row count | 1,470 | _fill_ | |
| UAT-02 | Compare attrition count with source filter (Attrition = Yes) | 237 | _fill_ | |
| UAT-03 | Recalculate attrition rate independently | 16.12% in dashboard, SQL and Python | _fill_ | |
| UAT-04 | Select Department = Sales | 446 employees, 92 leavers, 20.63%; relevant visuals update | _fill_ | |
| UAT-04b | Select Overtime = Yes | 416 employees, 127 leavers, 30.53% | _fill_ | |
| UAT-05 | Clear filters (Reset) | Full-population view returns (1,470 / 237 / 16.12%) | _fill_ | |
| UAT-06 | Inspect small segments (e.g. Manager in Human Resources, n=11) | Count and rate remain visible; flagged "small group" | _fill_ | |
| UAT-07 | Review labels and formats | Titles, units and percentages clear; Yes/No colors consistent | _fill_ | |
| UAT-08 | Privacy check | No employee_number or employee-level table anywhere in the report | _fill_ | |

## 15. Traceability
| Business requirement | Functional requirement | Dashboard element | UAT |
|---|---|---|---|
| BR-01 | FR-01, FR-02, FR-05 | Page 1 KPI cards | UAT-01, 02, 03 |
| BR-02 | FR-04 | Slicers, drill-through, reset button | UAT-04, 05 |
| BR-03 | FR-03 | Page 2 segment visuals, Page 3 matrix | UAT-04b |
| BR-04 | FR-05, FR-06 | Counts in labels/tooltips, small-group flag | UAT-06 |
| BR-05 | FR-07 | Definitions text box, Last Refreshed | UAT-07 |
| BR-06 | FR-08 | No identifiers or employee tables | UAT-08 |

## 16. Deliverables
Requirements document (this file), data dictionary and quality summary, SQL scripts (00-04), Python cleaning script and EDA notebook, Power BI dashboard (`powerbi/hr_attrition_dashboard.pbix`), insights and recommendations report, repository README.

## 17. Timeline (indicative)
| Phase | Effort |
|---|---|
| Discovery | 0.5-1 day |
| Data understanding | 0.5-1 day |
| Cleaning and validation | 1 day |
| Analysis | 1-2 days |
| Dashboard | 2-3 days |
| QA and reporting | 1-2 days |

## 18. Sign-off
| Role | Name | Date |
|---|---|---|
| Business sponsor (simulated) | | |
| Analyst | | |
