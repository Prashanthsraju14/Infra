# Project and Environment Variables

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "infra"

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 20
    error_message = "Project name must be between 1 and 20 characters."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

# Network Variables

variable "name" {
  description = "Application/Stack name for resource naming"
  type        = string
  default     = "infra"

  validation {
    condition     = can(regex("^[a-z0-9-]{1,63}$", var.name))
    error_message = "Name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR block."
  }
}

variable "azs" {
  description = "Availability zones (2-3 for high availability)"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]

  validation {
    condition     = length(var.azs) >= 2 && length(var.azs) <= 3
    error_message = "Must specify between 2 and 3 availability zones."
  }
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks mapped to AZ"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.0.1.0/24"
    "ap-south-1b" = "10.0.2.0/24"
  }

  validation {
    condition     = length(var.public_subnets) >= 2
    error_message = "Must define at least 2 public subnets for high availability."
  }
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks mapped to AZ"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.0.10.0/24"
    "ap-south-1b" = "10.0.11.0/24"
  }

  validation {
    condition     = length(var.private_subnets) >= 2
    error_message = "Must define at least 2 private subnets for high availability."
  }
}

variable "database_subnets" {
  description = "Database subnet CIDR blocks mapped to AZ"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.0.20.0/24"
    "ap-south-1b" = "10.0.21.0/24"
  }

  validation {
    condition     = length(var.database_subnets) >= 2
    error_message = "Must define at least 2 database subnets for RDS failover."
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnet outbound internet access"
  type        = bool
  default     = true
}

# Tagging Variables

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Owner      = "DevOps"
    Department = "Infrastructure"
    CostCenter = "Engineering"
  }
}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
