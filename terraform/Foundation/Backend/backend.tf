  terraform {
    backend "s3" {
      bucket         = "training-foundation-tfstate"
      key            = "foundation/backend/terraform.tfstate"
      region         = "ap-south-1"
      use_lockfile     = true
      encrypt        = true
    }
 }