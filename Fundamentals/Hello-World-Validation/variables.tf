variable "aws_region" {
  description = "AWS region to deploy resources"

  validation {
  condition     = can(regex("^us-", var.aws_region))
  error_message = "Region must start with 'us-'."
}
}

variable "ami_id" {
  description = "The AMI to use for EC2"

  validation {
    condition     = can(regex("^ami-[a-f0-9]{8,17}$", var.ami_id))
    error_message = "AMI ID must start with 'ami-' followed by 8 to 17 hexadecimal characters."
  }

}

variable "instance_type" {
  description = "EC2 instance type"

  validation {
  condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
  error_message = "Allowed instance types: t2.micro, t3.micro, t3.small."
}
}

variable "ssh_user" {
  description = "SSH username for the EC2 instance"
  type        = string
  default     = "ec2-user"

  validation {
    condition     = length(var.ssh_user) > 0
    error_message = "SSH username cannot be empty."
  }
}

variable "ssh_password" {
  description = "SSH password for the EC2 instance"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.ssh_password) >= 8
    error_message = "SSH password must be at least 8 characters long."
  }
}
