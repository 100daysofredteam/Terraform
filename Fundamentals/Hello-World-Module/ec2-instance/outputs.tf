output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.tf-module-demo.public_ip
}

output "ssh_user" {
  description = "SSH username"
  value       = var.ssh_user
}

output "ssh_password" {
  description = "SSH password"
  value       = var.ssh_password
  sensitive   = true
}
