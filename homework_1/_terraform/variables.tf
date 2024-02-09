variable "credentials" {
  description = "My Google Cloud Platform service user credentials"
  default     = "/Users/peter/Sources/data-engineering-zoomcamp/terraform/keys/creds.json"
}

variable "project" {
  description = "My Google project name"
  default     = "heroic-artifact-412919"
}

variable "region" {
  description = "My Google project region"
  default     = "europe-west10"
}

variable "location" {
  description = "My Google project location"
  default     = "EU"
}

variable "bq_ds_nm" {
  description = "My Google BigQuery dataset name"
  default     = "demo_dataset"
}

variable "gcs_bckt_nm" {
  description = "My Google Cloud Storage bucket name"
  default     = "heroic-artifact-412919-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket storage class"
  default     = "STANDARD"
}