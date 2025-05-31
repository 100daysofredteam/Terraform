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

output "public_subnet_cidr" {
  value = module.public_subnet.cidr_block
}

output "internet_gateway_id" {
  value = module.internet_gateway.igw_id
}

output "public_route_table_id" {
  value = module.route_tables.public_route_table_id
}

output "security_group_id" {
  value = module.ec2_sg.sg_id
}

output "aws_ssm_ec2_machine_id" {
  value = module.aws_ssm_ec2.ec2_instance_id
}

output "aws_ssm_ec2_public_ip" {
  value = module.aws_ssm_ec2.ec2_public_ip
}

output "aws_ssm_ec2_private_ip" {
  value = module.aws_ssm_ec2.ec2_private_ip
}


output "ssh_key_pair_name" {
  value = module.ec2_ssh_key.key_pair_name
}

