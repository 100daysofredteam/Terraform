variable "aws_region" {
  description = "AWS region to deploy resources"
}

variable "ami_id" {
  description = "Ubuntu AMI ID that supports cloud-init and SSH"
  type        = string
}

variable "ssh_user" {
  description = "Username for SSH login"
  type        = string
  default     = "redteam"
}

variable "ssh_password" {
  description = "Password for the SSH user"
  type        = string
  sensitive   = true
}

variable "instance_type" {
  description = "EC2 instance type"
}
