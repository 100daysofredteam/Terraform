

provider "aws" {
  region = var.aws_region
}

# Fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# Get your public IP address
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

# Create a local variable to hold the IP in CIDR format
locals {
  my_ip_cidr = "${trim(data.http.my_ip.response_body, "\n")}/32"
}

resource "aws_instance" "hello" {
  ami           = var.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
    #!/bin/bash
    echo 'ec2-user:YourSecurePassword123' | chpasswd
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl restart sshd
  EOF

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "TerraformHelloWorld"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH from my IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
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

