output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.hello.public_ip
}

output "ssh_login" {
  value = "ssh ${var.ssh_user}@${aws_instance.hello.public_ip}"
}

output "ssh_password" {
  value     = data.aws_ssm_parameter.ec2-user.value
  sensitive = true
}
