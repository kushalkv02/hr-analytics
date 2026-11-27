# Data

**Source:** IBM HR Analytics Employee Attrition & Performance (public sample dataset, widely mirrored on Kaggle).
**Expected file:** `WA_Fn-UseC_-HR-Employee-Attrition.csv` (commonly 1,470 rows, 35 columns, binary `Attrition` Yes/No).

Confirm the exact file version, row count and column names after downloading; copies differ.

## Setup
1. Download the CSV from the original source and place it in `data/raw/` (leave it untouched).
2. Record the source URL, download date and row count below.
3. Run `python python/01_clean_data.py` to create `data/processed/hr_employee_clean.csv`.

| Item | Value |
|---|---|
| Source URL | _fill in_ |
| Download date | _fill in_ |
| Rows / columns | _fill in_ |

The raw and processed CSVs are git-ignored. Check the dataset terms and link to the original source rather than redistributing it.

**Limitation:** static learning dataset, not a live workforce feed; it may not represent any real organization.
