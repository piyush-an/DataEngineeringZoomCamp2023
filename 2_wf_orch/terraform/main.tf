terraform {
  required_version = ">= 1.0"
  backend "local" {} # Can change from "local" to "gcs" (for google) or "s3" (for aws), if you would like to preserve your tf-state online
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.49.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  # Configuration options
}

# Data Lake Bucket
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "data-lake-bucket" {
  name                        = "${local.data_lake_bucket}_${var.project}"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90 // days
    }
  }
}

# DWH
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset
resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.BQ_DATASET
  project                    = var.project
  location                   = var.region
  delete_contents_on_destroy = true
}


resource "google_bigquery_table" "green_tbl" {
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  table_id            = "green"
  deletion_protection = false
  schema = jsonencode(
    [
      {
        "mode" : "NULLABLE",
        "name" : "VendorID",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "tpep_pickup_datetime",
        "type" : "TIMESTAMP"
      },
      {
        "mode" : "NULLABLE",
        "name" : "tpep_dropoff_datetime",
        "type" : "TIMESTAMP"
      },
      {
        "mode" : "NULLABLE",
        "name" : "passenger_count",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "trip_distance",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "RatecodeID",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "store_and_fwd_flag",
        "type" : "STRING"
      },
      {
        "mode" : "NULLABLE",
        "name" : "PULocationID",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "DOLocationID",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "payment_type",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "fare_amount",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "extra",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "mta_tax",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "tip_amount",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "tolls_amount",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "improvement_surcharge",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "total_amount",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "congestion_surcharge",
        "type" : "FLOAT64"
      }
    ]
  )
}


resource "google_bigquery_table" "yellow_tbl" {
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  table_id            = "yellow"
  deletion_protection = false
  schema = jsonencode(
    [
      {
        "mode" : "NULLABLE",
        "name" : "VendorID",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "tpep_pickup_datetime",
        "type" : "TIMESTAMP"
      },
      {
        "mode" : "NULLABLE",
        "name" : "tpep_dropoff_datetime",
        "type" : "TIMESTAMP"
      },
      {
        "mode" : "NULLABLE",
        "name" : "passenger_count",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "trip_distance",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "RatecodeID",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "store_and_fwd_flag",
        "type" : "STRING"
      },
      {
        "mode" : "NULLABLE",
        "name" : "PULocationID",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "DOLocationID",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "payment_type",
        "type" : "INT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "fare_amount",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "extra",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "mta_tax",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "tip_amount",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "tolls_amount",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "improvement_surcharge",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "total_amount",
        "type" : "FLOAT64"
      },
      {
        "mode" : "NULLABLE",
        "name" : "congestion_surcharge",
        "type" : "FLOAT64"
      }
    ]
  )
}

