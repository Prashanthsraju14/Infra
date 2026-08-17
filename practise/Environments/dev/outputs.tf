output "ec2_id" {
  value = module.ec2_instance.ec2_id
}

output "private_ip" {
  value = module.ec2_instance.private_ip
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}