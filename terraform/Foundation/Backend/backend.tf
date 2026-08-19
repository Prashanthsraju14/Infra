#   terraform {
#     backend "s3" {
#       bucket         = "infra-foundation-tfstate-723591018998"
#       key            = "foundation/backend/terraform.tfstate"
#       region         = "ap-south-1"
#       use_lockfile     = true
#       encrypt        = true
#     }
#  }