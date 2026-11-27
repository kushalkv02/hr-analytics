#!/usr/bin/env python3
"""
HR Analytics | Step 1: profile, validate and clean the raw IBM HR attrition CSV.

Input : data/raw/WA_Fn-UseC_-HR-Employee-Attrition.csv   (never modified)
Output: data/processed/hr_employee_clean.csv             (column order matches sql/00_create_table.sql)
        documentation/data_quality_summary.md            (auto-generated audit log)

Run from the repo root:  python python/01_clean_data.py
"""
import re
import sys
from datetime import date
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw" / "WA_Fn-UseC_-HR-Employee-Attrition.csv"
OUT = ROOT / "data" / "processed" / "hr_employee_clean.csv"
REPORT = ROOT / "documentation" / "data_quality_summary.md"

# Columns that carry no information in this dataset (constant); verified below before dropping.
CONSTANT_COLS = ["employee_count", "over18", "standard_hours"]

# Documented band boundaries (lower bound inclusive, upper bound exclusive).
AGE_BINS = [0, 25, 35, 45, 55, 200]
AGE_LABELS = ["<25", "25-34", "35-44", "45-54", "55+"]
TENURE_BINS = [0, 2, 5, 10, 100]
TENURE_LABELS = ["0-1", "2-4", "5-9", "10+"]

log = []  # lines for the data-quality summary


def note(line=""):
    print(line)
    log.append(line)


def to_snake(name: str) -> str:
    name = re.sub(r"(?<!^)(?=[A-Z])", "_", name.strip()).lower()
    return {"over_time": "overtime"}.get(name, name)


def main() -> int:
    if not RAW.exists():
        print(f"Raw file not found: {RAW}\nSee data/README.md for download instructions.")
        return 1

    df = pd.read_csv(RAW, encoding="utf-8-sig")  # utf-8-sig strips a BOM if present
    failures = []

    note("# Data Quality Summary")
    note(f"_Generated {date.today().isoformat()} by python/01_clean_data.py_\n")
    note("## 1. Structure")
    note(f"- Source file: `{RAW.name}`")
    note(f"- Rows: {df.shape[0]:,}  |  Columns: {df.shape[1]}")

    df.columns = [to_snake(c) for c in df.columns]

    # --- Nulls & duplicates -------------------------------------------------
    note("\n## 2. Nulls and duplicates")
    nulls = df.isna().sum()
    note(f"- Columns with nulls: {int((nulls > 0).sum())}")
    if (nulls > 0).any():
        note(nulls[nulls > 0].to_string())
        failures.append("Null values present - investigate before loading")
    dup_rows = int(df.duplicated().sum())
    dup_ids = int(df["employee_number"].duplicated().sum())
    note(f"- Fully duplicated rows: {dup_rows}")
    note(f"- Duplicate employee_number values: {dup_ids}")
    if dup_ids:
        failures.append("Duplicate employee_number values - rows may not be one-per-employee")

    # --- Outcome field ------------------------------------------------------
    note("\n## 3. Attrition field")
    df["attrition"] = df["attrition"].astype(str).str.strip()
    note(df["attrition"].value_counts(dropna=False).to_string())
    if not set(df["attrition"].unique()) <= {"Yes", "No"}:
        failures.append("Attrition contains values other than Yes/No")

    # --- Categorical profile ------------------------------------------------
    note("\n## 4. Categorical values")
    for col in df.select_dtypes(include=["object", "string"]).columns:
        vals = sorted(df[col].dropna().unique())
        note(f"- `{col}` ({len(vals)}): {', '.join(map(str, vals))}")

    # --- Range checks -------------------------------------------------------
    note("\n## 5. Range checks")
    note(f"- age: {df['age'].min()}-{df['age'].max()}")
    note(f"- monthly_income: {df['monthly_income'].min():,}-{df['monthly_income'].max():,}")
    note(f"- years_at_company: {df['years_at_company'].min()}-{df['years_at_company'].max()}")
    bad_tenure = int((df["years_at_company"] > df["total_working_years"]).sum())
    note(f"- Rows where years_at_company > total_working_years: {bad_tenure}")
    if bad_tenure:
        note("  (review: tenure should not exceed total career length)")
    if (df["monthly_income"] <= 0).any():
        failures.append("Non-positive monthly_income found")

    # --- Drop constant columns (only if truly constant) ---------------------
    note("\n## 6. Constant columns dropped")
    for col in CONSTANT_COLS:
        if col in df.columns:
            if df[col].nunique() == 1:
                note(f"- `{col}` = {df[col].iloc[0].item() if hasattr(df[col].iloc[0], 'item') else df[col].iloc[0]!r} for all rows -> dropped")
                df = df.drop(columns=col)
            else:
                note(f"- WARNING: `{col}` is not constant in this file - kept; update the DDL to match")

    # --- Derived fields -----------------------------------------------------
    df["attrition_flag"] = (df["attrition"] == "Yes").astype(int)
    df["age_band"] = pd.cut(df["age"], AGE_BINS, labels=AGE_LABELS, right=False).astype(str)
    df["tenure_band"] = pd.cut(
        df["years_at_company"], TENURE_BINS, labels=TENURE_LABELS, right=False
    ).astype(str)
    note("\n## 7. Derived fields")
    note(f"- `age_band` boundaries: {', '.join(AGE_LABELS)}")
    note(f"- `tenure_band` (years at company): {', '.join(TENURE_LABELS)}")
    note("- `attrition_flag`: 1 = Yes, 0 = No")

    # --- Headline numbers for reconciliation -------------------------------
    leavers = int(df["attrition_flag"].sum())
    note("\n## 8. Headline numbers (use to reconcile SQL and Power BI)")
    note(f"- Total employees: {len(df):,}")
    note(f"- Leavers (Attrition = Yes): {leavers:,}")
    note(f"- Active (Attrition = No): {len(df) - leavers:,}")
    note(f"- Attrition rate: {100 * leavers / len(df):.2f}%")

    if failures:
        note("\n## FAILED CHECKS")
        for f in failures:
            note(f"- {f}")
        REPORT.write_text("\n".join(log) + "\n")
        print("\nStopped: fix the failed checks above before loading.")
        return 2

    OUT.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(OUT, index=False)
    REPORT.write_text("\n".join(log) + "\n")
    print(f"\nWrote {OUT.relative_to(ROOT)} ({df.shape[0]:,} rows, {df.shape[1]} columns)")
    print("Column order:", ",".join(df.columns))
    return 0


if __name__ == "__main__":
    sys.exit(main())
