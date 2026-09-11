terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.google_cloud_platform_project_identifier
  region  = var.geographical_data_center_region
}

resource "google_storage_bucket" "raw_landing_bucket" {
  name                        = "${var.google_cloud_platform_project_identifier}-d0-raw-landing"
  location                    = var.geographical_data_center_region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  versioning {
    enabled = true
  }
}

resource "google_bigquery_dataset" "staged_enforced_dataset" {
  dataset_id                  = "d1_staged_enforced"
  friendly_name               = "D1 Staged Enforced Dataset"
  description                 = "Strictly validated data store for student onboarding analytics."
  location                    = var.geographical_data_center_region
  default_table_expiration_ms = 31536000000 
  labels = {
    environment = "staging"
  }
}

resource "google_bigquery_table" "student_onboarding_table" {
  dataset_id          = google_bigquery_dataset.staged_enforced_dataset.dataset_id
  table_id            = "student_onboarding_records"
  deletion_protection = true
  schema = <<EOF
[
  {"name": "submission_identifier", "type": "STRING", "mode": "REQUIRED"},
  {"name": "student_legal_name", "type": "STRING", "mode": "REQUIRED"},
  {"name": "has_learning_difficulty", "type": "BOOLEAN", "mode": "REQUIRED"},
  {"name": "requires_learning_support_assistant_matching", "type": "BOOLEAN", "mode": "REQUIRED"},
  {"name": "submission_timestamp", "type": "TIMESTAMP", "mode": "REQUIRED"}
]
EOF
}

resource "google_bigquery_row_access_policy" "learning_support_assistant_matching_filter" {
  project          = var.google_cloud_platform_project_identifier
  dataset_id       = google_bigquery_dataset.staged_enforced_dataset.dataset_id
  table_id         = google_bigquery_table.student_onboarding_table.table_id
  policy_id        = "learning_support_assistant_analyst_row_filter"
  filter_predicate = "requires_learning_support_assistant_matching = true"
}
