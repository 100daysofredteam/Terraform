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

module "public_subnet_2" {
  source                  = "./modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  name                    = "redirector"
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
  source             = "./modules/route_tables"
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.internet_gateway.igw_id
  public_subnet_id   = module.public_subnet.subnet_id
  public_subnet_2_id = module.public_subnet_2.subnet_id
  private_subnet_id  = module.private_subnet.subnet_id
  environment        = terraform.workspace
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
    },
    {
      description = "RDP access to Kali EC2 from my IP"
      from_port   = 3390
      to_port     = 33900
      protocol    = "tcp"
      cidr_blocks = [local.my_ip_cidr]
    },
    {
      description = "Havoc C2 server access from within subnet"
      from_port   = 40056
      to_port     = 40056
      protocol    = "tcp"
      cidr_blocks = [var.public_subnet_cidr]
    },
    {
      description = "Port 443 access"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [var.public_subnet_2_cidr]
    },
    {
      description = "Port 8443 access"
      from_port   = 8443
      to_port     = 8443
      protocol    = "tcp"
      cidr_blocks = [var.public_subnet_2_cidr]
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

module "redirector_sg" {
  source      = "./modules/security_group"
  name        = "redirector-access"
  vpc_id      = module.vpc.vpc_id
  environment = terraform.workspace

  ingress_rules = [
    {
      description = "SSH access from my Public Subnet"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.public_subnet_cidr]
    },
    {
      description = "Port 8443 access"
      from_port   = 8443
      to_port     = 8443
      protocol    = "tcp"
      cidr_blocks = [local.my_ip_cidr]
    },
    {
      description = "HTTPS access"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP access"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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
  ami_id            = var.kali_ami_id
  instance_type     = var.kali_instance_type
  subnet_id         = module.public_subnet.subnet_id
  security_group_id = module.kali_sg.sg_id
  key_name          = module.attacker_ssh_key.key_pair_name
  instance_name     = "kali-attacker"
  environment       = terraform.workspace
  user_data = templatefile("${path.module}/scripts/kali_user_data.sh", {
    kali_password   = data.aws_ssm_parameter.rt-attacker.value
    private_key_b64 = base64encode(module.attacker_ssh_key.private_key)
  })
  volume_size = 30
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

module "redirector_ec2" {
  source            = "./modules/ec2_instance"
  ami_id            = var.redirector_ami_id
  instance_type     = var.redirector_instance_type
  subnet_id         = module.public_subnet_2.subnet_id
  key_name          = var.key_name
  instance_name     = "redirector-1"
  environment       = terraform.workspace
  user_data         = templatefile("${path.module}/scripts/redirector_user_data.sh", {})
  volume_size       = 10
  security_group_id = module.redirector_sg.sg_id
}

module "havocc2_ec2" {
  source        = "./modules/ec2_instance"
  ami_id        = var.havocc2_ami_id
  instance_type = var.havocc2_instance_type
  subnet_id     = module.public_subnet.subnet_id
  key_name      = var.key_name
  instance_name = "havoc-c2-server"
  environment   = terraform.workspace
  user_data = templatefile("${path.module}/scripts/havoc_c2_user_data.sh", {
    private_key_b64       = base64encode(module.attacker_ssh_key.private_key),
    redirector_private_ip = module.redirector_ec2.ec2_private_ip
  })
  volume_size       = 10
  security_group_id = module.kali_sg.sg_id
}

