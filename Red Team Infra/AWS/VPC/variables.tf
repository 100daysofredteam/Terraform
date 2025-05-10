variable "aws_region" {
  type        = string
  description = "AWS region to deploy infrastructure in"

  validation {
    condition     = length(trim(var.aws_region, " \t\n\r")) > 0
    error_message = "The aws_region variable must not be empty."
  }
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"

  validation {
    condition     = length(trim(var.aws_access_key, " \t\n\r")) > 0
    error_message = "The aws_access_key variable must not be empty."
  }
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true

  validation {
    condition     = length(trim(var.aws_secret_key, " \t\n\r")) > 0
    error_message = "The aws_secret_key variable must not be empty."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.10.0.0/16"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.vpc_cidr))
    error_message = "The VPC CIDR must be a valid CIDR range, e.g., 10.10.0.0/16"
  }
}
