
output "public_key" {
  value       = tls_private_key.this.public_key_openssh
  description = "The generated SSH public key"
}

output "private_key" {
  value       = tls_private_key.this.private_key_pem
  description = "The generated SSH public key"
}

output "key_pair_name" {
  value = aws_key_pair.this.key_name
}