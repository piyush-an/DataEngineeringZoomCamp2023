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
}


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
  schema = file("${path.module}/tbl_green_ddl.json")
}


resource "google_bigquery_table" "yellow_tbl" {
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  table_id            = "yellow"
  deletion_protection = false
  schema = file("${path.module}/tbl_yellow_ddl.json")
}

