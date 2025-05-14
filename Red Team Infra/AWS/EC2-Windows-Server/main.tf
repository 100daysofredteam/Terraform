module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  environment = terraform.workspace
}

module "public_subnet" {
  source                  = "./modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  name                    = "public"
  environment             = terraform.workspace
}

module "private_subnet" {
  source                  = "./modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  name                    = "private"
  environment             = terraform.workspace
}

module "internet_gateway" {
  source      = "./modules/internet_gateway"
  vpc_id      = module.vpc.vpc_id
  environment = terraform.workspace
}

module "route_tables" {
  source            = "./modules/route_tables"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.internet_gateway.igw_id
  public_subnet_id  = module.public_subnet.subnet_id
  private_subnet_id = module.private_subnet.subnet_id
  environment       = terraform.workspace
}

# Get the user's current public IP
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# Convert it to CIDR notation
locals {
  my_ip_cidr = "${trimspace(data.http.my_ip.response_body)}/32"
}

module "attacker_ssh_key" {
  source            = "./modules/ssh_key"
  key_name          = var.key_name
  environment       = terraform.workspace
  write_private_key = true
}

module "kali_sg" {
  source      = "./modules/security_group"
  name        = "kali-ssh-access"
  vpc_id      = module.vpc.vpc_id
  environment = terraform.workspace

  ingress_rules = [
    {
      description = "SSH access from my IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [local.my_ip_cidr, var.public_subnet_cidr]
    },
    {
      description = "RDP access from my IP"
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = [local.my_ip_cidr]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "kali_ec2" {
  source            = "./modules/ec2_instance"
  ami_id            = var.kali_ami_id
  instance_type     = var.kali_instance_type
  subnet_id         = module.public_subnet.subnet_id
  security_group_id = module.kali_sg.sg_id
  key_name          = module.attacker_ssh_key.key_pair_name
  instance_name     = "kali-attacker"
  environment       = terraform.workspace
  user_data         = templatefile("${path.module}/scripts/kali_user_data.sh", {})
  volume_size       = 30
}


module "windows_ec2" {
  source            = "./modules/ec2_instance"
  ami_id            = var.windows_ami_id
  instance_type     = var.windows_instance_type
  subnet_id         = module.public_subnet.subnet_id
  key_name          = var.key_name
  instance_name     = "windows-attacker"
  environment       = terraform.workspace
  user_data         = templatefile("${path.module}/scripts/windows_user_data_template.ps1", {})
  volume_size       = 30
  security_group_id = module.kali_sg.sg_id
}

