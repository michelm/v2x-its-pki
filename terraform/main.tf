# All resources will be deployed in this GCP project
variable "project" {
    type        = string
    description = "Google Cloud Platform project identifier"
    default     = "vee2peekayai"
    sensitive   = true
}

# See https://cloud.google.com/storage/docs/locations for a list of supported locations
variable "bucket_location" {
    type        = string
    description = "Bucket deployment region, dual-region or multi-region"
    default     = "EU"
    sensitive   = true
}

# See https://cloud.google.com/storage/docs/storage-classes for a list of supported storage classes
variable "bucket_storage_class" {
    type        = string
    description = "Bucket storage class"
    default     = "STANDARD"
    sensitive   = true
}

# Create the storage bucket for the ECTL web service
resource "google_storage_bucket" "ectl-web-certs" {
    name          = "${var.project}-ectl-web-certs"
    location      = var.bucket_location
    storage_class = var.bucket_storage_class
    force_destroy = true
    project       = var.project

    public_access_prevention = "enforced"
    uniform_bucket_level_access = true
}

## TODO: upload the ECTL certificate(s) to the bucket

## TODO: start the ECTL web service

# Create the storage bucket for the TLM web service
resource "google_storage_bucket" "tlm-web-certs" {
    name          = "${var.project}-tlm-web-certs"
    location      = var.bucket_location
    storage_class = var.bucket_storage_class
    force_destroy = true
    project       = var.project

    public_access_prevention = "enforced"
    uniform_bucket_level_access = true
}

## TODO: upload the TLM certificate(s) to the bucket

## TODO: start the TLM web service
