output "instance_public_ip" {
  value       = module.remote_ec2.public_ip
  description = "The public IP of the EC2 instance"
}

output "ssh_command" {
  value       = "ssh ${var.ssh_user}@${module.remote_ec2.public_ip}"
  description = "Use this command to SSH into your EC2 instance"
}
