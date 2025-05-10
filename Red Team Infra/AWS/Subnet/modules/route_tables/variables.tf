variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID for public route"
}

variable "public_subnet_id" {
  type        = string
  description = "ID of the public subnet"
}

variable "private_subnet_id" {
  type        = string
  description = "ID of the private subnet"
}

variable "environment" {
  type        = string
  description = "Environment name for tagging"
}
