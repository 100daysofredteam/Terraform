provider "aws" {
  region = var.aws_region
}

# Get your public IP
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  my_ip_cidr = "${trimspace(data.http.my_ip.response_body)}/32"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security group to allow SSH only from current IP
resource "aws_security_group" "ssh_access" {
  name        = "remote-ec2-ssh"
  description = "Allow SSH from my IP only"
  vpc_id      = data.aws_vpc.default.id

  ingress {
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

# Use remote EC2 module from Terraform Registry
module "remote_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name          = "redteam-remote-ec2"
  ami           = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids       = [aws_security_group.ssh_access.id]
  associate_public_ip_address  = true

  user_data = <<-EOF
              #!/bin/bash
              echo '${var.ssh_user}:${var.ssh_password}' | chpasswd
              sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sed -i 's/^ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
              systemctl restart sshd
            EOF

  tags = {
    Project = "100DaysOfRedTeamInfra"
  }
}
