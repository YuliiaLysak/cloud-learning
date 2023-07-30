resource "google_storage_bucket" "bucket" {
  name          = "tf-bucket-230602"
  location      = "US"
  force_destroy = true
  uniform_bucket_level_access = true
}