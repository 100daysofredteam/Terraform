variable "key_name" {
  type        = string
  description = "Name to assign to the SSH key pair in AWS"
  validation {
    condition     = length(var.key_name) > 0
    error_message = "key_name must not be empty."
  }
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, redteam, etc.)"
  validation {
    condition     = length(var.environment) > 0
    error_message = "environment must not be empty."
  }
}

variable "write_private_key" {
  type        = bool
  default     = false
  description = "Set to true if you want to write the private key to disk (not recommended for production)"
}