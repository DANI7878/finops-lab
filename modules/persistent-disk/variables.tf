variable "name" {
  description = "Disk name. Lowercase letters, digits and hyphens, max 63 characters."
  type        = string

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.name))
    error_message = "name must start with a letter, use only lowercase letters, digits and hyphens, and be at most 63 characters."
  }
}

variable "zone" {
  description = "Zone the disk lives in."
  type        = string
}

variable "size_gb" {
  description = "Disk size in GB."
  type        = number
  default     = 10

  validation {
    condition     = var.size_gb >= 10
    error_message = "size_gb must be at least 10."
  }
}

variable "type" {
  description = "Disk type."
  type        = string
  default     = "pd-standard"

  validation {
    condition     = contains(["pd-standard", "pd-balanced", "pd-ssd"], var.type)
    error_message = "type must be one of pd-standard, pd-balanced, pd-ssd."
  }
}

variable "labels" {
  description = "Labels applied to the disk and its snapshot."
  type        = map(string)
  default     = {}
}

variable "create_snapshot" {
  description = "Also create a snapshot of the disk."
  type        = bool
  default     = false
}

variable "snapshot_name" {
  description = "Snapshot name. Defaults to <name>-snap."
  type        = string
  default     = null
}
