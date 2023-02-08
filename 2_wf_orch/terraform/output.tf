output "project-id" {
  value       = var.project
  description = "Your GCP Project ID"
}

output "bucket-name" {
  value       = google_storage_bucket.data-lake-bucket.name
  description = "Bucket name"
}

output "bq-dataset-name" {
  value       = google_bigquery_dataset.dataset.id
  description = "Big Query dataset name"
}

output "table-green-name" {
  value       = google_bigquery_table.green_tbl.id
  description = "Big Query table name"
}

output "table-yellow-name" {
  value       = google_bigquery_table.yellow_tbl.id
  description = "Big Query table name"
}
