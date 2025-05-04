variable "aws_region" {
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}


variable "ssh_user" {
  description = "Username for SSH login"
  default     = "ec2-user"
}

variable "ssh_password" {
  description = "Password for SSH login"
  sensitive   = true
}
