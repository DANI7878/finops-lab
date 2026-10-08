variable "name" {
  description = "Address name. Lowercase letters, digits and hyphens, max 63 characters."
  type        = string

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.name))
    error_message = "name must start with a letter, use only lowercase letters, digits and hyphens, and be at most 63 characters."
  }
}

variable "region" {
  description = "Region to reserve the external address in."
  type        = string
}

variable "labels" {
  description = "Labels applied to the address."
  type        = map(string)
  default     = {}
}
