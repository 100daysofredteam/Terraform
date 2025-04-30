variable "region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "red-team-sg"
}

variable "allowed_ingress_ports" {
  description = "List of allowed inbound ports"
  type        = list(number)
}

variable "allowed_cidrs" {
  description = "List of CIDR blocks allowed to access"
  type        = list(string)
}

variable "tags" {
  description = "Tags to assign to the resource"
  type        = map(string)
  default     = {
    Environment = "RedTeam"
    ManagedBy   = "100 Days of Red Team"
  }
}
