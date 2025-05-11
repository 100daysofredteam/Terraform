output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the created VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_id" {
  value = module.public_subnet.subnet_id
}

output "private_subnet_id" {
  value = module.private_subnet.subnet_id
}

output "public_subnet_cidr" {
  value = module.public_subnet.cidr_block
}

output "private_subnet_cidr" {
  value = module.private_subnet.cidr_block
}

output "internet_gateway_id" {
  value = module.internet_gateway.igw_id
}

output "public_route_table_id" {
  value = module.route_tables.public_route_table_id
}

output "private_route_table_id" {
  value = module.route_tables.private_route_table_id
}

output "security_group_id" {
  value = module.kali_sg.sg_id
}

output "attacker_machine_id" {
  value = module.kali_ec2.ec2_instance_id
}

output "attacker_ssh_login" {
  value = "Attacker machine login: ssh ${var.ssh_user}@${module.kali_ec2.ec2_public_ip}"
}