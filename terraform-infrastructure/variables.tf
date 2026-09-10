variable "google_cloud_platform_project_identifier" {
  type        = string
  description = "The verified Google Cloud Platform project identification string."
  default     = "habot-connect-staging-environment"
}

variable "geographical_data_center_region" {
  type        = string
  description = "The primary geographical location for cloud resources."
  default     = "asia-south1"
}