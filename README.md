# Bike Sharing Analytics with DuckDB and dbt

A small analytics engineering project using daily bike-sharing data.
Python loads a public CSV into DuckDB. dbt cleans the data, builds analysis-ready tables, and runs data quality tests.

## Overview structure
bike-sharing-dbt/
├── .github/
│   └── workflows/
│       ├── ci.yml                      # Build and test pull requests
│       └── prod.yml                    # Build production and save artifacts
├── scripts/
│   └── load_raw.py                     # Download CSV and load raw table
├── data/
│   └── day.csv                         # Downloaded input; gitignored
├── database/
│   └── bike_sharing.duckdb              # Local database; gitignored
├── macros/
│   └── generate_schema_name.sql        # Choose schemas for dev, CI, and prod
├── models/
│   ├── staging/
│   │   ├── sources.yml                 # Declare Python-loaded raw table
│   │   ├── stg_bike_daily.sql           # Rename columns and cast types
│   │   └── schema.yml                  # Model documentation and tests
│   ├── intermediate/
│   │   ├── int_bike_daily.sql           # Add shared categories and calculations
│   │   └── schema.yml                  # Model documentation and tests
│   └── marts/
│       ├── fct_daily_rentals.sql        # One row per day
│       ├── mart_monthly_demand.sql      # One row per month
│       ├── mart_weather_demand.sql      # One row per year, weather, and day type
│       ├── mart_seasonal_demand.sql     # One row per year, season, and day type
│       └── schema.yml                  # Model documentation and tests
├── tests/
│   └── assert_rental_counts_valid.sql  # Check rental counts and totals
├── dbt_project.yml                     # Project and model configuration
├── profiles.yml                        # DuckDB connection and targets
├── requirements.txt                    # Python dependencies
├── README.md                           # Project overview and setup
└── .gitignore                          # Exclude local and generated files

## Dataset

[UCI Bike Sharing](https://archive.ics.uci.edu/dataset/275/bike+sharing+dataset):
731 daily observations from Capital Bikeshare in 2011–2012.

The project uses `day.csv`, which includes rental counts, weather, seasons, and working-day indicators.

Source: Fanaee-T, H. (2013). Bike Sharing. UCI Machine Learning Repository.
License: CC BY 4.0.

## Tech stack

- Python: download the CSV and load raw data
- DuckDB: local analytical database
- dbt Core and dbt-duckdb: SQL models, tests, and documentation
- Git and GitHub: version control
- GitHub Actions: CI checks and production builds

## Architecture

```text
UCI CSV
  → Python loader
  → raw.bike_daily
  → staging: rename columns and cast types
  → intermediate: add shared categories and calculations
  → marts:
      fct_daily_rentals
      mart_monthly_demand
      mart_weather_demand
      mart_seasonal_demand
```

Staging and intermediate models are views. Marts are tables.
Tests check required values, uniqueness, categories, and rental counts.

## Environments and workflows

One DuckDB file contains separate model schemas:

- dev: development models
- ci: temporary CI models
- prod: staging, intermediate, and marts schemas

CI builds and tests pull requests into main.
CD builds production on pushes to main and saves the dbt manifest and DuckDB database as GitHub artifacts.

## Run locally

Requires Python 3.12. Run from the repository root.

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt

python scripts/load_raw.py
.venv/bin/dbt build --profiles-dir . --target dev
```

## Reference

The project structure and CI/CD approach are based on
[Mark Pham's dbt DuckDB CI/CD template](https://github.com/MarkPhamm/dbt_duckdb_cicd_template/tree/main).

This project uses a different dataset, a Python ingestion step, and bike-sharing models.