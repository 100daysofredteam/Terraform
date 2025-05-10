variable "vpc_id" {
  type        = string
  description = "ID of the VPC to place the subnet in"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the public subnet"
}

variable "availability_zone" {
  type        = string
  description = "AZ to deploy subnet in"
}

variable "environment" {
  type        = string
  description = "Environment tag (e.g., dev, prod)"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Whether to auto-assign public IPs to instances in this subnet"
  default     = false
}

variable "name" {
  type        = string
  description = "Name label to identify the subnet (e.g., public or private)"
}
