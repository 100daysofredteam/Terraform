provider "aws" {
  region = var.region
}

# Fetch default VPC
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "red_team_sg" {
  name        = var.sg_name
  description = "Security group for red team infrastructure"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allowed_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
