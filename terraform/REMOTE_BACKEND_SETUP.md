# Remote Backend Setup Guide

## Step-by-Step Process

### Phase 1: Create Foundation Backend Infrastructure (Local State)

The Foundation/Backend contains the S3 bucket and DynamoDB table needed for remote state.

#### 1.1 Initialize and Deploy Foundation/Backend

```bash
cd terraform/Foundation/Backend

# Initialize with local state
terraform init

# Review the plan (check bucket name will be generated)
terraform plan

# Apply to create S3 bucket and DynamoDB table
terraform apply
```

#### 1.2 Get the Bucket Name from Output

```bash
# Get the S3 bucket name that was created
terraform output terraform_state_bucket

# Example output: infra-foundation-tfstate-123456789012
```

#### 1.3 (Optional) Migrate Foundation/Backend to Remote State

Once S3 bucket exists, you can migrate Foundation/Backend's own state to S3:

```bash
# Edit versions.tf - uncomment the backend "s3" block
# Update the bucket name with actual value

# Reinitialize with remote backend
terraform init
# When prompted, choose "yes" to migrate state to S3
```

---

### Phase 2: Configure Dev Environment with Remote Backend

#### 2.1 Update Dev Backend Configuration

```bash
cd ../../Environments/Dev

# 1. Get the bucket name from Foundation/Backend output
BUCKET_NAME="infra-foundation-tfstate-123456789012"  # Replace with actual

# 2. Edit backend-remote.tf and replace ACCOUNT_ID with actual bucket name
# OR create a backend config file (preferred for automation)

# 3. Create backend config file
cat > backend-config.hcl << EOF
bucket         = "$BUCKET_NAME"
key            = "dev/vpc/terraform.tfstate"
region         = "ap-south-1"
encrypt        = true
dynamodb_table = "terraform-locks"
EOF
```

#### 2.2 Option A: Using Backend Config File (Recommended)

```bash
# Initialize with backend config file
terraform init -backend-config=backend-config.hcl

# Review the plan
terraform plan

# Apply
terraform apply
```

#### 2.2 Option B: Update providers.tf Directly

Edit `terraform/Environments/Dev/providers.tf` and update the backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "infra-foundation-tfstate-123456789012"  # Your bucket name
    key            = "dev/vpc/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

Then run:
```bash
terraform init
terraform plan
terraform apply
```

---

### Phase 3: Repeat for UAT and Prod

Follow the same process for UAT and Prod environments:

```bash
# UAT
cd ../../UAT
terraform init -backend-config=backend-config.hcl
terraform plan
terraform apply

# Prod
cd ../Prod
terraform init -backend-config=backend-config.hcl
terraform plan
terraform apply
```

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    AWS Account                          │
│                                                         │
│  ┌────────────────────────────────────────────────┐   │
│  │   Foundation/Backend (Bootstrap)                │   │
│  │                                                 │   │
│  │   ┌──────────────────────────────────────┐    │   │
│  │   │  S3 Bucket for Terraform State      │    │   │
│  │   │  (infra-foundation-tfstate-XXXXX)   │    │   │
│  │   └──────────────────────────────────────┘    │   │
│  │                                                 │   │
│  │   ┌──────────────────────────────────────┐    │   │
│  │   │  DynamoDB Table: terraform-locks    │    │   │
│  │   │  (For state locking)                 │    │   │
│  │   └──────────────────────────────────────┘    │   │
│  └────────────────────────────────────────────────┘   │
│              ↑                                         │
│              │ stores state in                        │
│              │                                         │
│  ┌────────────┴──────────────────────────────────┐   │
│  │  Dev / UAT / Prod Environments                │   │
│  │                                                │   │
│  │  ├─ Environments/Dev/terraform.tfstate (S3)  │   │
│  │  ├─ Environments/UAT/terraform.tfstate (S3)  │   │
│  │  └─ Environments/Prod/terraform.tfstate (S3) │   │
│  └────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Command Summary

```bash
# 1. Deploy Foundation Backend (creates S3 + DynamoDB)
cd terraform/Foundation/Backend
terraform init
terraform apply
BUCKET_NAME=$(terraform output -raw terraform_state_bucket)
echo "Bucket Name: $BUCKET_NAME"

# 2. Deploy Dev VPC with remote backend
cd ../../Environments/Dev
cat > backend-config.hcl << EOF
bucket         = "$BUCKET_NAME"
key            = "dev/vpc/terraform.tfstate"
region         = "ap-south-1"
encrypt        = true
dynamodb_table = "terraform-locks"
EOF

terraform init -backend-config=backend-config.hcl
terraform apply

# 3. Repeat for UAT
cd ../UAT
cat > backend-config.hcl << EOF
bucket         = "$BUCKET_NAME"
key            = "uat/vpc/terraform.tfstate"
region         = "ap-south-1"
encrypt        = true
dynamodb_table = "terraform-locks"
EOF

terraform init -backend-config=backend-config.hcl
terraform apply

# 4. Repeat for Prod
cd ../Prod
cat > backend-config.hcl << EOF
bucket         = "$BUCKET_NAME"
key            = "prod/vpc/terraform.tfstate"
region         = "ap-south-1"
encrypt        = true
dynamodb_table = "terraform-locks"
EOF

terraform init -backend-config=backend-config.hcl
terraform apply
```

---

## Troubleshooting

### S3 Bucket Already Exists Error
If you get "BucketAlreadyExists" error, check if the bucket was created previously.

```bash
# List Terraform state buckets
aws s3 ls | grep tfstate

# Option 1: Use existing bucket in terraform.tfvars
variable "bucket_name" = "your-existing-bucket-name"

# Option 2: Destroy and recreate (be careful with existing state!)
terraform destroy
terraform apply
```

### DynamoDB Lock Table Not Found
Make sure the DynamoDB table name in backend config matches what Foundation/Backend created.

```bash
# Check DynamoDB tables
aws dynamodb list-tables --region ap-south-1
```

### Backend Already Configured
If you see "backend already configured" error:

```bash
# Remove local backend state
rm -rf .terraform/

# Reinitialize with backend config
terraform init -backend-config=backend-config.hcl
```

---

## Key Points

✅ Foundation/Backend **must** be deployed first
✅ Use backend config file (`-backend-config`) for flexibility
✅ Keep bucket name consistent across all environments
✅ DynamoDB table handles state locking (prevents concurrent applies)
✅ S3 versioning keeps state history for rollback

---

## Security Best Practices

1. **Encrypt State Files**: Already enabled (AES-256)
2. **Block Public Access**: Foundation/Backend blocks all public access
3. **MFA Delete**: Consider enabling on S3 bucket
4. **State File Access**: Limit IAM permissions to S3 and DynamoDB
5. **Audit Logging**: Enable S3 access logging and CloudTrail
