output "bucket_name" {
  value       = google_storage_bucket.bucket.name
  description = "The name of the Google Storage bucket being created"
}

output "bucket_location" {
  value       = google_storage_bucket.bucket.location
  description = "The location of the Google Storage bucket being created"
}