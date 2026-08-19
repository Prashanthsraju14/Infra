output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private application subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  description = "Database subnet IDs"
  value       = module.vpc.database_subnet_ids
}

output "public_subnet_ids_by_az" {
  description = "Public subnet IDs by AZ"
  value       = module.vpc.public_subnet_ids_by_az
}

output "private_subnet_ids_by_az" {
  description = "Private subnet IDs by AZ"
  value       = module.vpc.private_subnet_ids_by_az
}

output "database_subnet_ids_by_az" {
  description = "Database subnet IDs by AZ"
  value       = module.vpc.database_subnet_ids_by_az
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}

output "nat_public_ip" {
  description = "NAT Gateway public IP"
  value       = module.vpc.nat_public_ip
}

output "eks_cluster_name" {

  value = module.eks.cluster_name
}


output "eks_cluster_endpoint" {

  value = module.eks.cluster_endpoint
}


output "eks_cluster_arn" {

  value = module.eks.cluster_arn
}


output "eks_cluster_version" {

  value = module.eks.cluster_version
}


output "eks_cluster_role_arn" {

  value = module.eks.cluster_role_arn
}


output "eks_node_role_arn" {

  value = module.eks.node_role_arn
}


output "eks_node_group_name" {

  value = module.eks.node_group_name
}