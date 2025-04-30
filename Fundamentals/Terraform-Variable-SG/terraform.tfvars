region               = "us-east-1"
allowed_ingress_ports = [22, 443]
allowed_cidrs        = ["203.0.113.5/32", "198.51.100.10/32"]
tags = {
  Operation  = "Redirector Security Group"
  Expiry     = "2025-05-30"
  CreatedBy  = "100 Days of Red Team"
}
