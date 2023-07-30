variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "qwiklabs-gcp-04-a672b83b4483"
}
variable "region" {
  description = "Region in which to provision resources."
  type        = string
  default     = "us-central1"
}
variable "zone" {
  description = "Zone in which to provision resources."
  type        = string
  default     = "us-central1-a"
}