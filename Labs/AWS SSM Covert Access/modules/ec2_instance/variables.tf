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

variable "iam_instance_profile" {
  description = "The IAM profile to attach to the EC2 instance."
  type        = string
  default     = ""
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


variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "key_name" {
  type        = string
  description = "The name of the SSH key pair to associate with the EC2 instance"
  validation {
    condition     = length(var.key_name) > 0
    error_message = "key_name must not be empty."
  }
}


variable "user_data" {
  description = "Rendered user data script as string"
  type        = string
  default     = ""
}

variable "volume_size" {
  type        = number
  description = "Root volume size in GB"
  default     = 20
}
