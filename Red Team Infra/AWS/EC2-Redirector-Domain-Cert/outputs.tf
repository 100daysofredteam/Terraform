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

output "public_subnet_2_id" {
  value = module.public_subnet_2.subnet_id
}

output "private_subnet_id" {
  value = module.private_subnet.subnet_id
}

output "public_subnet_cidr" {
  value = module.public_subnet.cidr_block
}

output "public_subnet_2_cidr" {
  value = module.public_subnet_2.cidr_block
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

output "redirector_security_group_id" {
  value = module.redirector_sg.sg_id
}

output "kali_attacker_machine_id" {
  value = module.kali_ec2.ec2_instance_id
}

output "kali_attacker_public_ip" {
  value = module.kali_ec2.ec2_public_ip
}

output "kali_attacker_private_ip" {
  value = module.kali_ec2.ec2_private_ip
}

output "windows_attacker_machine_id" {
  value = module.windows_ec2.ec2_instance_id
}

output "windows_attacker_public_ip" {
  value = module.windows_ec2.ec2_public_ip
}

output "windows_attacker_private_ip" {
  value = module.windows_ec2.ec2_private_ip
}

output "havocc2_ec2_machine_id" {
  value = module.havocc2_ec2.ec2_instance_id
}

output "havocc2_ec2_public_ip" {
  value = module.havocc2_ec2.ec2_public_ip
}

output "havocc2_ec2_private_ip" {
  value = module.havocc2_ec2.ec2_private_ip
}


output "redirector_ec2_machine_id" {
  value = module.redirector_ec2.ec2_instance_id
}

output "redirector_ec2_public_ip" {
  value = module.redirector_ec2.ec2_public_ip
}

output "redirector_ec2_private_ip" {
  value = module.redirector_ec2.ec2_private_ip
}

output "ssh_key_pair_name" {
  value = module.attacker_ssh_key.key_pair_name
}


output "domain_name_zone_id" {
  value = data.cloudflare_zone.redirector_domain.zone_id
}
