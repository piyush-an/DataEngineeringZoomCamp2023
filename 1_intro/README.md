## Data Ingestion

### Application Run - Local
1. Run Containers
   ```shell
   docker-compose up -d
   ```
2. Build docker image
   ```shell
   docker build -t taxi_ingest:v01 .
   ```
2. Run the ingest pipelines
   ```
   docker run --network=back-end taxi_ingest:v01 --user=root --password=root --host=postgresdb --port=5432 --db=ny_taxi --table_name=yellow_taxi_trips --url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

   docker run --network=back-end taxi_ingest:v02 --user=root --password=root --host=postgresdb --port=5432 --db=ny_taxi --table_name=green_taxi_trips --url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz"

   docker run --network=back-end taxi_ingest:v03 --user=root --password=root --host=postgresdb --port=5432 --db=ny_taxi --table_name=green_taxi_zone --url="https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv"
   ```
