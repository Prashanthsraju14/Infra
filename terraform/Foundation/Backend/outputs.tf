output "terraform_state_bucket" {
  description = "Terraform state bucket"
  value       = aws_s3_bucket.tfstate.bucket
}

