output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the VPC"
}

output "vpc_cidr" {
  value       = aws_vpc.this.cidr_block
  description = "The CIDR block of the VPC"
}
