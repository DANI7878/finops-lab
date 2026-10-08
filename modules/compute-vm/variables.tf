variable "name" {
  description = "Instance name. Lowercase letters, digits and hyphens, max 63 characters."
  type        = string

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.name))
    error_message = "name must start with a letter, use only lowercase letters, digits and hyphens, and be at most 63 characters."
  }
}

variable "zone" {
  description = "Zone to create the instance in, for example us-central1-a."
  type        = string
}

variable "machine_type" {
  description = "Machine type. e2-micro is covered by the always-free tier in us-west1, us-central1 and us-east1."
  type        = string
  default     = "e2-micro"
}

variable "image" {
  description = "Boot disk image."
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB."
  type        = number
  default     = 10

  validation {
    condition     = var.boot_disk_size_gb >= 10
    error_message = "boot_disk_size_gb must be at least 10."
  }
}

variable "boot_disk_type" {
  description = "Boot disk type."
  type        = string
  default     = "pd-standard"

  validation {
    condition     = contains(["pd-standard", "pd-balanced", "pd-ssd"], var.boot_disk_type)
    error_message = "boot_disk_type must be one of pd-standard, pd-balanced, pd-ssd."
  }
}

variable "network" {
  description = "VPC network name or self link."
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Subnetwork name or self link. Required for custom-mode VPCs, leave null for the default network."
  type        = string
  default     = null
}

variable "enable_external_ip" {
  description = "Attach an ephemeral external IP. Off by default: it is safer and external IPs are billed."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels applied to the instance and its boot disk. Cost allocation depends on these."
  type        = map(string)
  default     = {}
}

variable "network_tags" {
  description = "Network tags, used by firewall rules."
  type        = list(string)
  default     = []
}

variable "metadata" {
  description = "Extra instance metadata. OS Login is enabled unless you override it."
  type        = map(string)
  default     = {}
}

variable "service_account_email" {
  description = "Service account to attach. Null attaches none."
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "OAuth scopes for the attached service account."
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "resource_policies" {
  description = "Self links of resource policies, for example an instance schedule that stops the VM outside business hours."
  type        = list(string)
  default     = []
}

variable "enable_secure_boot" {
  description = "Enable Secure Boot on the shielded VM."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Protect the instance from accidental deletion."
  type        = bool
  default     = false
}
