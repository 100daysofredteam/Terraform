output "subnet_id" {
  value = aws_subnet.this.id
}

output "cidr_block" {
  value = var.cidr_block
}
