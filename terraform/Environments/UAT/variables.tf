variable "name" {
  description = "Project name"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "uat"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.1.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnets" {
  description = "Public subnets"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.1.1.0/24"
    "ap-south-1b" = "10.1.2.0/24"
  }
}

variable "private_subnets" {
  description = "Private application subnets"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.1.10.0/24"
    "ap-south-1b" = "10.1.11.0/24"
  }
}

variable "database_subnets" {
  description = "Database subnets"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.1.20.0/24"
    "ap-south-1b" = "10.1.21.0/24"
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default = {
    Environment = "uat"
    ManagedBy   = "Terraform"
  }
}
