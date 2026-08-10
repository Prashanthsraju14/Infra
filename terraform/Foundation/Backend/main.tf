###############################################
# Get the AWS Account ID of the authenticated user
###############################################

data "aws_caller_identity" "current" {}
# This data source retrieves information about the current AWS identity.
# We use it to obtain the AWS Account ID so bucket names remain globally unique.


###############################################
# Local Variables
###############################################




###############################################
# Create the S3 Bucket
###############################################

resource "aws_s3_bucket" "tfstate" {

  # Bucket name generated above
  bucket = local.bucket_name

  # Allows bucket deletion even when objects exist.
  # Usually false in production.
  force_destroy = false

  # Apply tags
  tags = merge(
    local.common_tags,
    {
      Name = local.bucket_name
    }
  )
}


###############################################
# Enable Versioning
###############################################

resource "aws_s3_bucket_versioning" "tfstate" {

  # Bucket to enable versioning on
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {

    # Keeps previous versions of the Terraform state.
    # This allows recovery if the state is accidentally overwritten.

    status = "Enabled"
  }
}


###############################################
# Enable Server-Side Encryption
###############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {

  # Bucket to encrypt
  bucket = aws_s3_bucket.tfstate.id

  rule {

    apply_server_side_encryption_by_default {

      # AES256 encryption managed by Amazon S3

      sse_algorithm = "AES256"

      # Alternatively, you could use:
      #
      # sse_algorithm = "aws:kms"
      #
      # for AWS KMS encryption.
    }
  }
}


###############################################
# Block Public Access
###############################################

resource "aws_s3_bucket_public_access_block" "tfstate" {

  bucket = aws_s3_bucket.tfstate.id

  # Prevent public ACLs
  block_public_acls = true

  # Prevent public bucket policies
  block_public_policy = true

  # Ignore any public ACLs
  ignore_public_acls = true

  # Restrict public buckets
  restrict_public_buckets = true
}


###############################################
# Bucket Ownership Controls
###############################################

resource "aws_s3_bucket_ownership_controls" "tfstate" {

  bucket = aws_s3_bucket.tfstate.id

  rule {

    # Bucket owner automatically owns every uploaded object.
    # ACLs are disabled.

    object_ownership = "BucketOwnerEnforced"
  }
}


