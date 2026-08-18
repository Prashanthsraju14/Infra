terraform {
  required_version = "~> 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Remote backend will be configured after Foundation/Backend is deployed
  # Use: terraform init -backend-config=backend-config.hcl
  # Or uncomment and update the bucket name below
  
  backend "s3" {
    # bucket         = "infra-foundation-tfstate-ACCOUNT_ID"  # From Foundation/Backend output
    # key            = "prod/vpc/terraform.tfstate"
    # region         = "ap-south-1"
    # dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Environment = "prod"
      Project     = "Infrastructure"
      ManagedBy   = "Terraform"
    }
  }
}
