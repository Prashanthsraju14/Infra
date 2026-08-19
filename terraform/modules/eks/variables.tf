variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private application subnet IDs for EKS"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS managed nodes"
  type        = string
  default     = "t3.small"
}

variable "node_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "node_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 2
}

variable "node_disk_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}


variable "admin_principal_arn" {
  description = "IAM principal that will administer the EKS cluster"
  type        = string
}