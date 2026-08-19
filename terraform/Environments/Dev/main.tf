# Dev VPC Infrastructure
# Production-grade VPC with high availability across 2 AZs

module "vpc" {
  source = "../../modules/vpc"

  # Project identification
  name        = var.name
  environment = var.environment

  # Network configuration
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  # Feature flags
  enable_nat_gateway   = var.enable_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tagging strategy
  tags = merge(
    var.common_tags,
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
      Region      = var.aws_region
    }
  )
}


module "eks" {
  source = "../../modules/eks"

  cluster_name = "${var.name}-${var.environment}-eks"

  kubernetes_version = var.kubernetes_version

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  environment = var.environment

  node_instance_type = var.node_instance_type

  node_min_size     = var.node_min_size
  node_desired_size = var.node_desired_size
  node_max_size     = var.node_max_size

  node_disk_size = var.node_disk_size

  admin_principal_arn = var.admin_principal_arn

  tags = {
    Project     = var.name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}