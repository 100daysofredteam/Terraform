resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = var.user_data

  tags = {
    Name    = "100daysofredteam-ec2-${var.instance_name}-${var.environment}"
    Project = "Red Team Infrastructure"
  }

  lifecycle {
    create_before_destroy = true
  }
}
