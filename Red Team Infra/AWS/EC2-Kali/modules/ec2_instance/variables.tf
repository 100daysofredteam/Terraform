variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance (e.g., a Kali Linux AMI)"
  type        = string
  validation {
    condition     = length(var.ami_id) > 0
    error_message = "The ami_id variable must not be empty."
  }
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance (e.g., t2.micro)"
  type        = string
  validation {
    condition     = length(var.instance_type) > 0
    error_message = "The instance_type variable must not be empty."
  }
}

variable "subnet_id" {
  description = "The subnet ID where the EC2 instance will be launched"
  type        = string
  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "The subnet_id variable must not be empty."
  }
}

variable "security_group_id" {
  description = "The ID of the security group to attach to the EC2 instance"
  type        = string
  validation {
    condition     = length(var.security_group_id) > 0
    error_message = "The security_group_id variable must not be empty."
  }
}

variable "instance_name" {
  description = "The name to assign to the EC2 instance"
  type        = string
  validation {
    condition     = length(var.instance_name) > 0
    error_message = "The instance_name variable must not be empty."
  }
}

variable "user_data" {
  description = "User data script to run on EC2 instance startup (usually a base64-encoded shell script)"
  type        = string
  validation {
    condition     = length(var.user_data) > 0
    error_message = "The user_data variable must not be empty."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}