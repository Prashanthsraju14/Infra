locals {

  # ----------------------------------------------------------
  # Common Tags
  # ----------------------------------------------------------

  common_tags = merge(
    {
      Project     = var.name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )


  # ----------------------------------------------------------
  # Public Subnets
  # ----------------------------------------------------------

  public_subnets = {
    for az, cidr in var.public_subnets :
    az => {
      az   = az
      cidr = cidr
    }
  }


  # ----------------------------------------------------------
  # Private Application Subnets
  # ----------------------------------------------------------

  private_subnets = {
    for az, cidr in var.private_subnets :
    az => {
      az   = az
      cidr = cidr
    }
  }


  # ----------------------------------------------------------
  # Database Subnets
  # ----------------------------------------------------------

  database_subnets = {
    for az, cidr in var.database_subnets :
    az => {
      az   = az
      cidr = cidr
    }
  }


  # ----------------------------------------------------------
  # ONE NAT GATEWAY
  #
  # NAT Gateway will always be created in AZ[0]
  # ----------------------------------------------------------

  nat_az = var.enable_nat_gateway ? var.azs[0] : null
}