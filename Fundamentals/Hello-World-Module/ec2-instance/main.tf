resource "aws_instance" "tf-module-demo" {
  ami                    = var.ami
  instance_type          = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids = [var.security_group_id]

  user_data = <<EOF
#!/bin/bash
useradd -m ${var.ssh_user}
echo "${var.ssh_user}:${var.ssh_password}" | chpasswd
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
EOF

  tags = {
    Name = var.name
  }
}
