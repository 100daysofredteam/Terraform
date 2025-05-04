output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ssh_login" {
  value = "ssh ${module.ec2.ssh_user}@${module.ec2.public_ip}"
}

output "ssh_password" {
  value     = module.ec2.ssh_password
  sensitive = true
}
