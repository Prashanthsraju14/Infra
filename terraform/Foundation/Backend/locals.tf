locals {

  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    {
      Name        = local.name_prefix
      Project     = var.project_name
      Environment = var.environment
      Application = var.project_name
      ManagedBy   = "Terraform"
      CreatedBy   = "Terraform"
      Owner       = var.owner
      CostCenter  = var.cost_center
      Repository  = "Terraform-Manifests"
    },
    var.tags
  )

  # Generate the S3 bucket name.
  # If var.bucket_name is provided, use it.
  # Otherwise generate:
  # <project>-<environment>-tfstate-<account-id>
  #
  # Example:
  # observability-dev-tfstate-123456789012
  #
  # lower() converts everything to lowercase.
  # replace() replaces "." with "-" because S3 bucket names cannot contain dots in some scenarios.

  bucket_name = lower(
    replace(
      coalesce(
        var.bucket_name,
        "${var.project_name}-${var.environment}-tfstate-${data.aws_caller_identity.current.account_id}"
      ),
      ".",
      "-"
    )
  )



}