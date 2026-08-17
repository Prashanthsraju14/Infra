variable "name" {
  description = "Project or application name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)

  validation {
    condition     = length(var.azs) == 2
    error_message = "Exactly 2 Availability Zones are required."
  }
}

variable "public_subnets" {
  description = "Public subnet CIDRs mapped to Availability Zones"
  type        = map(string)

  validation {
    condition     = length(var.public_subnets) == 2
    error_message = "Exactly 2 public subnets are required."
  }
}

variable "private_subnets" {
  description = "Private application subnet CIDRs mapped to Availability Zones"
  type        = map(string)

  validation {
    condition     = length(var.private_subnets) == 2
    error_message = "Exactly 2 private subnets are required."
  }
}

variable "database_subnets" {
  description = "Private database subnet CIDRs mapped to Availability Zones"
  type        = map(string)

  validation {
    condition     = length(var.database_subnets) == 2
    error_message = "Exactly 2 database subnets are required."
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "CloudWatch Flow Log retention"
  type        = number
  default     = 30
}

variable "enable_dns_support" {
  description = "Enable VPC DNS support"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable VPC DNS hostnames"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}
}