# Load the raw data from the UCI Bike Sharing Dataset
#  into a local DuckDB database.
from pathlib import Path
import io
import ssl
import urllib.request
import zipfile

import certifi
import duckdb

ROOT = Path(__file__).resolve().parents[1]
URL = (
    "https://archive.ics.uci.edu/static/public/275/"
    "bike+sharing+dataset.zip"
)

csv_path = ROOT / "data" / "day.csv"
db_path = ROOT / "database" / "bike_sharing.duckdb"

csv_path.parent.mkdir(exist_ok=True)
db_path.parent.mkdir(exist_ok=True)

# Download the dataset once and keep the CSV locally.
if not csv_path.exists():
    print("Downloading dataset...")
    context = ssl.create_default_context(cafile=certifi.where())

    with urllib.request.urlopen(
        URL, context=context, timeout=30
    ) as response:
        archive_bytes = response.read()

    with zipfile.ZipFile(io.BytesIO(archive_bytes)) as archive:
        csv_path.write_bytes(archive.read("day.csv"))

# Persist the raw data in a local DuckDB database.
with duckdb.connect(str(db_path)) as connection:
    connection.execute("CREATE SCHEMA IF NOT EXISTS raw")

    connection.execute(
        """
        CREATE OR REPLACE TABLE raw.bike_daily AS
        SELECT *
        FROM read_csv(?, header=true, all_varchar=true)
        """,
        [str(csv_path)],
    )

    row_count = connection.execute(
        "SELECT COUNT(*) FROM raw.bike_daily"
    ).fetchone()[0]

    print(f"Loaded {row_count} rows into raw.bike_daily")

    print(connection.execute(
        """
        SELECT dteday, casual, registered, cnt
        FROM raw.bike_daily
        ORDER BY dteday
        LIMIT 5
        """
    ).fetchall())