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

variable "aws_access_key" {
  description = "Access Key for AWS account"
  type        = string


  validation {
    condition     = length(var.aws_access_key) > 0
    error_message = "Access Key cannot be empty."
  }
}

variable "aws_secret_key" {
  description = "Secret Key for AWS account"
  type        = string


  validation {
    condition     = length(var.aws_secret_key) > 0
    error_message = "Secret Key cannot be empty."
  }
}
