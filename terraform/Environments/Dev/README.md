# Dev Environment - Production Grade VPC Infrastructure

## Overview

This directory contains the Terraform configuration for the **Development environment** VPC infrastructure. This is a production-grade setup with:

- ✅ High availability across 2 availability zones
- ✅ Remote state management with S3 + DynamoDB locking
- ✅ Comprehensive input validation
- ✅ Proper resource naming conventions
- ✅ Consistent tagging strategy
- ✅ Public, private, and database subnets
- ✅ NAT Gateway for outbound internet access
- ✅ Internet Gateway for inbound connectivity

## Architecture

```
VPC (10.0.0.0/16)
├── Public Subnets (2 AZs)
│   ├── ap-south-1a: 10.0.1.0/24
│   └── ap-south-1b: 10.0.2.0/24
├── Private Subnets (2 AZs)
│   ├── ap-south-1a: 10.0.10.0/24
│   └── ap-south-1b: 10.0.11.0/24
├── Database Subnets (2 AZs)
│   ├── ap-south-1a: 10.0.20.0/24
│   └── ap-south-1b: 10.0.21.0/24
├── Internet Gateway (IGW)
├── NAT Gateway (in public subnet)
└── Route Tables (public + private)
```

## Files

| File | Purpose |
|------|---------|
| `providers.tf` | AWS provider and backend S3 configuration |
| `variables.tf` | Input variables with validation |
| `main.tf` | VPC module instantiation |
| `outputs.tf` | Exported values for other modules |
| `versions.tf` | Terraform and provider versions |
| `terraform.tfvars` | Dev-specific variable values |
| `README.md` | This file |

## Prerequisites

1. **AWS Account** with credentials configured
2. **Terraform** >= 1.15.0
3. **Foundation Backend** deployed (creates S3 bucket and DynamoDB table)
4. **Backend S3 bucket** must exist before deploying

## Deployment

### 1. Initialize Terraform

```bash
cd terraform/Environments/Dev
terraform init
```

### 2. Review Changes

```bash
terraform plan
```

### 3. Apply Configuration

```bash
terraform apply
```

## Variables

All variables are defined in `variables.tf` with:
- Type validation
- Value validation (regex, length, allowed values)
- Default values
- Descriptive comments

### Key Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `project_name` | `infra` | Project identifier |
| `environment` | `dev` | Environment (dev/uat/prod) |
| `aws_region` | `ap-south-1` | AWS region |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `azs` | `[ap-south-1a, ap-south-1b]` | Availability zones |
| `enable_nat_gateway` | `true` | Enable NAT for private subnets |

### Customization

To override defaults, create `terraform.tfvars`:

```hcl
project_name = "myproject"
environment  = "dev"
vpc_cidr     = "10.0.0.0/16"
azs          = ["ap-south-1a", "ap-south-1b"]

tags = {
  Owner      = "Your Name"
  CostCenter = "Your Cost Center"
}
```

## Outputs

All outputs are exported and can be referenced by other modules:

```bash
terraform output vpc_id
terraform output public_subnet_ids
terraform output nat_gateway_public_ip
```

Key outputs:
- `vpc_id` - VPC ID
- `vpc_cidr` - VPC CIDR block
- `public_subnet_ids` - Public subnet IDs by AZ
- `private_subnet_ids` - Private subnet IDs by AZ
- `database_subnet_ids` - Database subnet IDs by AZ
- `nat_gateway_id` - NAT Gateway ID
- `nat_gateway_public_ip` - NAT Gateway Elastic IP

## Remote State Management

State is stored in S3 with DynamoDB locking:

- **S3 Bucket**: `infra-foundation-tfstate-723591018998`
- **State Key**: `dev/vpc/terraform.tfstate`
- **Lock Table**: `terraform-locks`
- **Region**: `ap-south-1`
- **Encryption**: Enabled (AES-256)

### State Management Commands

```bash
# List current state
terraform state list

# Show specific resource
terraform state show module.vpc.aws_vpc.this

# Check remote state in S3
aws s3 ls s3://infra-foundation-tfstate-723591018998/dev/vpc/

# Manual unlock (if needed)
terraform force-unlock <LOCK_ID>
```

## Tagging Strategy

All resources include consistent tags:

```hcl
{
  Owner       = "DevOps"
  Department  = "Infrastructure"
  CostCenter  = "Engineering"
  Environment = "dev"
  Project     = "infra"
  ManagedBy   = "Terraform"
}
```

## Security Best Practices

✅ **Remote State**: Encrypted S3 backend with DynamoDB locking
✅ **High Availability**: 2 AZs minimum
✅ **Network Segmentation**: Public, private, and database subnets
✅ **Outbound Access**: NAT Gateway for private subnets
✅ **DNS**: DNS hostnames and resolution enabled
✅ **Input Validation**: All variables validated
✅ **Audit Trail**: State versioning enabled

## Monitoring & Troubleshooting

### Check VPC Status

```bash
aws ec2 describe-vpcs --vpc-ids <vpc-id> --region ap-south-1
aws ec2 describe-subnets --filters "Name=vpc-id,Values=<vpc-id>" --region ap-south-1
aws ec2 describe-nat-gateways --filters "Name=vpc-id,Values=<vpc-id>" --region ap-south-1
```

### View Logs

```bash
# Terraform logs
TF_LOG=DEBUG terraform plan

# Check state lock
aws dynamodb scan --table-name terraform-locks --region ap-south-1
```

### Common Issues

**Error: S3 bucket doesn't exist**
- Ensure Foundation/Backend is deployed first
- Verify bucket name matches in `providers.tf`

**Error: DynamoDB table not found**
- Check Foundation/Backend deployment
- Verify table name: `terraform-locks`

**Terraform plan hangs**
- Check DynamoDB locks: `aws dynamodb scan --table-name terraform-locks`
- Force unlock if needed: `terraform force-unlock <LOCK_ID>`

## Upgrade Path

Future considerations:
- VPC Peering (to UAT/Prod)
- AWS Transit Gateway (multi-VPC connectivity)
- VPC Flow Logs (network monitoring)
- Network ACLs (additional security)
- VPC Endpoints (private service access)

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning**: This will delete:
- VPC and all subnets
- Internet Gateway
- NAT Gateway and Elastic IP
- Route tables
- Security groups

## Support

For issues or questions:
1. Check Terraform logs: `TF_LOG=DEBUG terraform plan`
2. Verify AWS credentials: `aws sts get-caller-identity`
3. Check state file: `terraform show`
4. Review AWS console for resource status

## References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform State Management](https://www.terraform.io/language/state)
