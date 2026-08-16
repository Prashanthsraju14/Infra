terraform {
  required_version = ">=1.15.0,<2.0.0"
  required_providers {
    aws={
      source = "hashicrop/aws"
      version = "~>6.0"
    }
  }
}