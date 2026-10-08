variable "project_id" {
  description = "GCP project ID for the lab."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be 6-30 characters: lowercase letters, digits and hyphens, starting with a letter."
  }
}

variable "region" {
  description = "Region. Use us-west1, us-central1 or us-east1 to stay inside the always-free e2-micro."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone inside the region."
  type        = string
  default     = "us-central1-a"
}

variable "name_prefix" {
  description = "Prefix for resource names, so several copies of the lab can coexist. Include the trailing hyphen."
  type        = string
  default     = ""
}

variable "extra_labels" {
  description = "Extra labels merged into every resource."
  type        = map(string)
  default     = {}
}
