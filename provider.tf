provider "google" {
  project = var.project_id
  region  = var.region
  version = "3.44"
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  version = "3.44"
}

terraform {
  required_version = "0.13.5"

  backend "gcs" {
    bucket = "state_bucket_name"
    prefix = "project_id_here
  }
}