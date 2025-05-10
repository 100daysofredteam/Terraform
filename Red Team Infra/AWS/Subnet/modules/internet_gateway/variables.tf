variable "vpc_id" {
  type        = string
  description = "VPC to attach the internet gateway to"
}

variable "environment" {
  type        = string
  description = "Environment tag"
}
