
output "public_key" {
  value       = tls_private_key.this.public_key_openssh
  description = "The generated SSH public key"
}

output "key_pair_name" {
  value = aws_key_pair.this.key_name
}