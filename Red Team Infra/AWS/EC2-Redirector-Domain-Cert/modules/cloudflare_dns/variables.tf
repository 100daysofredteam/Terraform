variable "zone_id" {
  description = "Cloudflare Zone ID for the domain"
  type        = string

  validation {
    condition     = length(var.zone_id) > 0
    error_message = "Cloudflare Zone ID cannot be empty."
  }
}

variable "record_name" {
  description = "Subdomain for the record (e.g., 'teamserver' for teamserver.redteam.training)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$|^@$", var.record_name))
    error_message = "Record name must be alphanumeric, hyphenated, or '@' for apex domain."
  }
}

variable "record_type" {
  description = "Type of DNS record (A, CNAME, TXT etc.)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z]+$", var.record_type))
    error_message = "Record name must only contain alphabet characters."
  }
}

variable "record_value" {
  description = "IP address to point the A record to"
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.record_value))
    error_message = "Record value must be a valid IPv4 address (e.g., 192.168.1.1)."
  }
}

variable "ttl" {
  description = "Time to live in seconds"
  type        = number
  default     = 300

  validation {
    condition     = var.ttl >= 1 && var.ttl <= 86400
    error_message = "TTL must be between 60 and 86400 seconds."
  }
}

variable "proxied" {
  description = "Whether the record is proxied through Cloudflare"
  type        = bool
  default     = true
}