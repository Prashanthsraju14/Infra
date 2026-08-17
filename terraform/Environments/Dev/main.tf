# Dev Environment - Main Configuration

module "vpc" {
  source = "../../modules/vpc"

  name                 = var.name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  database_subnets     = var.database_subnets
  enable_nat_gateway   = var.enable_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}
