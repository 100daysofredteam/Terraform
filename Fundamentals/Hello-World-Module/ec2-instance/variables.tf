variable "ami" {
  type        = string
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t3.micro"
}

variable "name" {
  type        = string
  description = "Tag name for EC2 instance"
}

variable "ssh_user" {
  type        = string
  description = "Username for SSH"
}

variable "ssh_password" {
  type        = string
  description = "Password for SSH user"
  sensitive   = true
}

variable "security_group_id" {
  type        = string
  description = "Security group ID"
}
