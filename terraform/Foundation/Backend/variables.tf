variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region for backend resources"
  type        = string
}

variable "owner" {
  type        = string
  description = "Resource Owner"
}

variable "cost_center" {
  type        = string
  description = "Cost Center"
}

variable "bucket_name" {
  description = "Optional custom S3 bucket name for Terraform state"
  type        = string
  default     = null
}

variable "dynamodb_table_name" {
  description = "Optional custom DynamoDB table name for Terraform state locking"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Allow bucket destruction even when it contains objects"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}