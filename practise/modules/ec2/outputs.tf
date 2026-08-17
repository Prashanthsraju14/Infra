output "ec2_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "ec2_name" {
  description = "EC2 instance name"
  value       = aws_instance.web.tags["Name"]
}

output "private_ip" {
  description = "EC2 private IP"
  value       = aws_instance.web.private_ip
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web.public_ip
}