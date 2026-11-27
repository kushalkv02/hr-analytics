-- PostgreSQL | Step 0: create the analytical table.
-- Column order matches data/processed/hr_employee_clean.csv produced by python/01_clean_data.py.

DROP TABLE IF EXISTS hr_employee;

CREATE TABLE hr_employee (
    age                         INTEGER,
    attrition                   VARCHAR(3)  NOT NULL CHECK (attrition IN ('Yes','No')),
    business_travel             VARCHAR(30),
    daily_rate                  INTEGER,
    department                  VARCHAR(40),
    distance_from_home          INTEGER,
    education                   SMALLINT,
    education_field             VARCHAR(40),
    employee_number             INTEGER     PRIMARY KEY,   -- identifier: never show in public visuals
    environment_satisfaction    SMALLINT,
    gender                      VARCHAR(10),
    hourly_rate                 INTEGER,
    job_involvement             SMALLINT,
    job_level                   SMALLINT,
    job_role                    VARCHAR(40),
    job_satisfaction            SMALLINT,
    marital_status              VARCHAR(15),
    monthly_income              INTEGER,
    monthly_rate                INTEGER,
    num_companies_worked        SMALLINT,
    overtime                    VARCHAR(3),
    percent_salary_hike         SMALLINT,
    performance_rating          SMALLINT,
    relationship_satisfaction   SMALLINT,
    stock_option_level          SMALLINT,
    total_working_years         INTEGER,
    training_times_last_year    SMALLINT,
    work_life_balance           SMALLINT,
    years_at_company            INTEGER,
    years_in_current_role       INTEGER,
    years_since_last_promotion  INTEGER,
    years_with_curr_manager     INTEGER,
    attrition_flag              SMALLINT,
    age_band                    VARCHAR(10),
    tenure_band                 VARCHAR(10)
);

-- Load (psql). In pgAdmin use right-click table > Import/Export Data (header = on, delimiter = comma).
-- \copy hr_employee FROM 'data/processed/hr_employee_clean.csv' WITH (FORMAT csv, HEADER true);
