output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "Private application subnet IDs"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "database_subnet_ids" {
  description = "Database subnet IDs"
  value       = [for subnet in aws_subnet.database : subnet.id]
}

output "public_subnet_ids_by_az" {
  description = "Public subnet IDs by AZ"
  value = {
    for az, subnet in aws_subnet.public :
    az => subnet.id
  }
}

output "private_subnet_ids_by_az" {
  description = "Private subnet IDs by AZ"
  value = {
    for az, subnet in aws_subnet.private :
    az => subnet.id
  }
}

output "database_subnet_ids_by_az" {
  description = "Database subnet IDs by AZ"
  value = {
    for az, subnet in aws_subnet.database :
    az => subnet.id
  }
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = var.enable_nat_gateway ? aws_nat_gateway.this[0].id : null
}

output "nat_public_ip" {
  description = "NAT Gateway public IP"
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}