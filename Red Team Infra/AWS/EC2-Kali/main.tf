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

data "aws_ssm_parameter" "rt-attacker" {
  name            = "/100daysofredteam/attacker_ssh_password"
  with_decryption = true
}


module "kali_ec2" {
  source            = "./modules/ec2_instance"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.public_subnet.subnet_id
  security_group_id = module.kali_sg.sg_id
  instance_name     = "kali-attacker"
  environment       = terraform.workspace
  user_data         = <<EOF
#!/bin/bash
useradd -m ${var.ssh_user}
echo "${var.ssh_user}:${data.aws_ssm_parameter.rt-attacker.value}" | chpasswd
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
EOF
}