terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get the user's current public IP
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# Convert it to CIDR notation
locals {
  my_ip_cidr = "${trimspace(data.http.my_ip.response_body)}/32"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group to allow SSH from only the user's IP
resource "aws_security_group" "ssh_access" {
  name        = "100daysofredteam-ssh-access"
  description = "Allow SSH from current user IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access from public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Use the EC2 module
module "ec2" {
  source            = "./modules/ec2-instance"
  ami               = var.ami_id
  instance_type     = var.instance_type
  name              = "tf-module-demo-instance"
  ssh_user          = var.ssh_user
  ssh_password      = var.ssh_password
  security_group_id = aws_security_group.ssh_access.id
}
