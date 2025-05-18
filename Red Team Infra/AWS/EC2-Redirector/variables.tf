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

variable "public_subnet_2_cidr" {
  type        = string
  description = "CIDR block for the Public Subnet 2"
  default     = "10.10.1.0/24"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.public_subnet_2_cidr))
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

variable "kali_ami_id" {
  description = "AMI ID for Kali Linux"
  type        = string
  validation {
    condition     = length(var.kali_ami_id) > 0
    error_message = "AMI ID cannot be empty."
  }
}


variable "windows_ami_id" {
  description = "AMI ID for Kali Linux"
  type        = string
  validation {
    condition     = length(var.windows_ami_id) > 0
    error_message = "AMI ID cannot be empty."
  }
}

variable "havocc2_ami_id" {
  description = "AMI ID for Havoc C2 (Ubuntu 24.04)"
  type        = string
  validation {
    condition     = length(var.havocc2_ami_id) > 0
    error_message = "AMI ID cannot be empty."
  }
}


variable "redirector_ami_id" {
  description = "AMI ID for Redirector (Ubuntu 24.04)"
  type        = string
  validation {
    condition     = length(var.redirector_ami_id) > 0
    error_message = "AMI ID cannot be empty."
  }
}

variable "kali_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
  validation {
    condition     = length(var.kali_instance_type) > 0
    error_message = "Instance type cannot be empty."
  }

}

variable "windows_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
  validation {
    condition     = length(var.windows_instance_type) > 0
    error_message = "Instance type cannot be empty."
  }

}

variable "havocc2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
  validation {
    condition     = length(var.havocc2_instance_type) > 0
    error_message = "Instance type cannot be empty."
  }

}

variable "redirector_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
  validation {
    condition     = length(var.redirector_instance_type) > 0
    error_message = "Instance type cannot be empty."
  }

}

variable "key_name" {
  type        = string
  description = "The name of the SSH key pair to associate with the EC2 instance"
  validation {
    condition     = length(var.key_name) > 0
    error_message = "key_name must not be empty."
  }
}