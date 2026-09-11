variable "google_cloud_platform_project_identifier" {
  type        = string
  description = "The unique, immutable alphanumeric identifier of the target Google Cloud Platform project hosting all system landing zones."
  
  validation {
    condition     = length(var.google_cloud_platform_project_identifier) >= 6 && length(var.google_cloud_platform_project_identifier) <= 30
    error_message = "The Google Cloud Platform project identifier must be between 6 and 30 characters in length."
  }
}

variable "geographical_data_center_region" {
  type        = string
  description = "The specific geographical region within the Google Cloud Platform topology where infrastructure layers are provisioned."
  default     = "us-central1"

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.geographical_data_center_region))
    error_message = "The geographical region must follow valid Google Cloud Platform naming structures (e.g., 'us-central1' or 'europe-west3')."
  }
}
