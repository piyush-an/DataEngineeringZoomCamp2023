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
2. Run the ingest image
   ```
   docker run --network=back-end taxi_ingest:v01 --user=root --password=root --host=postgresdb --port=5432 --db=ny_taxi --table_name=yellow_taxi_trips --url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
   ```
