variable "ec2_name" {
  description = "Name of EC2 instance"
  type        = string
  default     = "dev"
}

variable "ami" {
  description = "AMI ID"
  type        = string
  default     = "ami-01a00762f46d584a1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "dev_keypair"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}
