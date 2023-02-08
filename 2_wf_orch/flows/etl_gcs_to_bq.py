from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials


@task(retries=3)
def extract_from_gcs(color: str, year: int, month: int) -> Path:
    """Download trip data from GCS"""
    gcs_path = f"data/{color}/{color}_tripdata_{year}-{month:02}.parquet"
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.get_directory(from_path=gcs_path, local_path=f"")
    return Path(f"{gcs_path}")


@task()
def transform(path: Path) -> pd.DataFrame:
    """Data cleaning example"""
    # print(f"PATH is {path}")
    df = pd.read_parquet(path)
    # print(f"pre: missing passenger count: {df['passenger_count'].isna().sum()}")
    # df["passenger_count"].fillna(0, inplace=True)
    # print(f"post: missing passenger count: {df['passenger_count'].isna().sum()}")
    return df


@task()
def write_bq(df: pd.DataFrame, color:str) -> None:
    """Write DataFrame to BiqQuery"""

    gcp_credentials_block = GcpCredentials.load("zoom-gcp-bq")

    df.to_gbq(
        destination_table=f"trips_data_all.{color}",
        project_id="vertical-set-375108",
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append",
    )


@flow(log_prints=True)
def etl_gcs_to_bq(color:str, month:int, year: int):
    """Main ETL flow to load data into Big Query"""
    path = extract_from_gcs(color, year, month)
    print(f"returned path: {path}")
    df = transform(path)
    print(f"Total number of rows processed for {color}-{month:02}-{year} data: {len(df)}")
    write_bq(df, color)


@flow(log_prints=True)
def etl_gcs_to_bq_parent(color:str = "yellow", months: list = [1,2], year: int = 2021):
    # print("IN FLOW")
    for month in months:
        etl_gcs_to_bq(color, month, year)
        # print(color, month, year)


if __name__ == "__main__":
    color = "yellow"
    months = [3]
    year = 2021
    # print("START FLOW")
    etl_gcs_to_bq_parent(color, months, year)
