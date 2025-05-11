variable "aws_region" {
  type        = string
  description = "AWS region to deploy infrastructure in"

  validation {
    condition     = length(trim(var.aws_region, " \t\n\r")) > 0
    error_message = "The aws_region variable must not be empty."
  }
}

variable "availability_zone" {
  type        = string
  description = "AZ to deploy the subnet in"

  validation {
    condition     = length(trim(var.availability_zone, " \t\n\r")) > 0
    error_message = "The aavailability_zone variable must not be empty."
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

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the Public Subnet"
  default     = "10.10.1.0/24"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.public_subnet_cidr))
    error_message = "The CIDR must be a valid CIDR range, e.g., 10.10.0.0/16"
  }
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the Private Subnet"
  default     = "10.10.1.0/24"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.private_subnet_cidr))
    error_message = "The CIDR must be a valid CIDR range, e.g., 10.10.0.0/16"
  }
}

variable "ami_id" {
  description = "AMI ID for Kali Linux"
  type        = string
  validation {
    condition     = length(var.ami_id) > 0
    error_message = "AMI ID cannot be empty."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
  validation {
    condition     = length(var.instance_type) > 0
    error_message = "Instance type cannot be empty."
  }

}

variable "ssh_user" {
  description = "Username for SSH login"
  type        = string
  validation {
    condition     = length(var.ssh_user) > 0
    error_message = "SSH username cannot be empty."
  }
}