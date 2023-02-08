from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from random import randint
import os
from prefect.tasks import task_input_hash
from datetime import timedelta


@task(retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def fetch(dataset_url: str) -> pd.DataFrame:
    """Read taxi data from web into pandas DataFrame"""
    print(f"dataset_url : {dataset_url}")
    df = pd.read_csv(dataset_url, engine='pyarrow')
    return df


@task(log_prints=True)
def clean(df: pd.DataFrame, color: str) -> pd.DataFrame:
    """Fix dtype issues"""
    if color == "yellow":
        df["tpep_pickup_datetime"] = pd.to_datetime(df["tpep_pickup_datetime"])
        df["tpep_dropoff_datetime"] = pd.to_datetime(df["tpep_dropoff_datetime"])
    else:
        df["lpep_pickup_datetime"] = pd.to_datetime(df["lpep_pickup_datetime"])
        df["lpep_dropoff_datetime"] = pd.to_datetime(df["lpep_dropoff_datetime"])
    print(df.head(2))
    print(f"columns: {df.dtypes}")
    print(f"rows: {len(df)}")
    return df


@task()
def write_local(df: pd.DataFrame, color: str, dataset_file: str) -> Path:
    """Write DataFrame out locally as parquet file"""
    # path = os.path.join(os.path.realpath(__file__),f"data\{color}\{dataset_file}.parquet")
    Path(f"data/{color}").mkdir(parents=True, exist_ok=True)
    path = Path(f"data/{color}/{dataset_file}.parquet")
    print(f"Path is : {path}")
    df.to_parquet(path, compression="gzip")
    return path


@task()
def write_gcs(path: Path) -> None:
    """Upload local parquet file to GCS"""
    gcs_block = GcsBucket.load("zoom-gcs")
    gcs_block.upload_from_path(from_path=path, to_path=path) # '/'.join(path.split('/')[1:])
    return


@flow()
def etl_web_to_gcs(color:str, month:int, year: int) -> None:
    """The main ETL function"""
    dataset_file = f"{color}_tripdata_{year}-{month:02}"
    dataset_url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{dataset_file}.csv.gz"
    print(f"Working Dir : {os.getcwd()}")
    df = fetch(dataset_url)
    df_clean = clean(df, color)
    path = write_local(df_clean, color, dataset_file)
    write_gcs(path)
    print(f"Number of row processed : {len(df_clean)}")

@flow()
def etl_web_to_gcs_parent(color:str = "yellow", months: list = [1,2], year: int = 2021):
    for month in months:
        etl_web_to_gcs(color, month, year)

if __name__ == "__main__":
    color = "green"
    months = [11]
    year = 2020
    etl_web_to_gcs_parent(color, months, year)