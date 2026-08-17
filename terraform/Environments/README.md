# VPC Terraform Module

This Terraform module creates a complete, production-ready VPC infrastructure on AWS with public, private, and database subnets.

## Module Structure

```
modules/vpc/
├── main.tf              # Core VPC resources
├── variables.tf         # Input variables
├── outputs.tf          # Exported outputs
├── versions.tf         # Provider versions
├── providers.tf        # Provider configuration
├── locals.tf          # Local variables and computed values
└── README.md          # Documentation

Environments/
├── Dev/               # Development environment
├── UAT/               # User acceptance testing environment
└── Prod/              # Production environment
```

## Features

- **Multi-AZ VPC**: Distributed across multiple availability zones
- **Public Subnets**: For internet-facing resources with IGW access
- **Private Subnets**: For application servers with NAT Gateway access
- **Database Subnets**: For RDS and other data services
- **Internet Gateway**: For public subnet internet connectivity
- **NAT Gateway**: For private subnet outbound internet access
- **Route Tables**: Separate routing for public and private subnets
- **Security Groups**: Default security group for VPC communication
- **DNS Support**: DNS hostnames and resolution enabled by default
- **EKS Ready**: Tagged for Kubernetes load balancers (public and internal)

## Network Architecture

### Development (Dev) - 10.0.0.0/16
- Public Subnets: 2 AZs (10.0.1.0/24, 10.0.2.0/24)
- Private Subnets: 2 AZs (10.0.10.0/24, 10.0.11.0/24)
- Database Subnets: 2 AZs (10.0.20.0/24, 10.0.21.0/24)

### UAT (User Acceptance Testing) - 10.1.0.0/16
- Public Subnets: 2 AZs (10.1.1.0/24, 10.1.2.0/24)
- Private Subnets: 2 AZs (10.1.10.0/24, 10.1.11.0/24)
- Database Subnets: 2 AZs (10.1.20.0/24, 10.1.21.0/24)

### Production (Prod) - 10.2.0.0/16
- Public Subnets: 3 AZs (10.2.1.0/24, 10.2.2.0/24, 10.2.3.0/24)
- Private Subnets: 3 AZs (10.2.10.0/24, 10.2.11.0/24, 10.2.12.0/24)
- Database Subnets: 3 AZs (10.2.20.0/24, 10.2.21.0/24, 10.2.22.0/24)

```
┌─────────────────────────────────────────────────┐
│              VPC (e.g., 10.0.0.0/16)             │
│                                                   │
│  ┌────────────────────────────────────────────┐ │
│  │         Internet Gateway                   │ │
│  └────────────────────────────────────────────┘ │
│                     │                            │
│  ┌──────────────────┴──────────────────────┐  │
│  │                                          │  │
│  │      Public Subnets (Route to IGW)      │  │
│  │  ┌──────────────┐  ┌──────────────┐    │  │
│  │  │ 10.0.1.0/24  │  │ 10.0.2.0/24  │    │  │
│  │  │   AZ-1       │  │   AZ-2       │    │  │
│  │  └──────────────┘  └──────────────┘    │  │
│  │                                          │  │
│  │     NAT Gateway (in Public Subnet)       │  │
│  │              │                           │  │
│  ├──────────────┼──────────────────────────┤  │
│  │              │                          │  │
│  │  ┌───────────┴──────────────────────┐  │  │
│  │  │                                   │  │  │
│  │  │  Private Subnets (Route to NAT)  │  │  │
│  │  │  ┌──────────────┐ ┌────────────┐ │  │  │
│  │  │  │ 10.0.10.0/24 │ │10.0.11.0/24│ │  │  │
│  │  │  │    AZ-1      │ │   AZ-2     │ │  │  │
│  │  │  └──────────────┘ └────────────┘ │  │  │
│  │  └───────────────────────────────────┘  │  │
│  │                                          │  │
│  │  ┌───────────────────────────────────┐  │  │
│  │  │  Database Subnets (Route to NAT)  │  │  │
│  │  │  ┌──────────────┐ ┌────────────┐  │  │  │
│  │  │  │ 10.0.20.0/24 │ │10.0.21.0/24│  │  │  │
│  │  │  │    AZ-1      │ │   AZ-2     │  │  │  │
│  │  │  └──────────────┘ └────────────┘  │  │  │
│  │  └───────────────────────────────────┘  │  │
│  └──────────────────────────────────────────┤  │
└─────────────────────────────────────────────────┘
```

## Module Variables

| Variable | Type | Default | Required | Description |
|----------|------|---------|----------|-------------|
| name | string | - | yes | Project name prefix |
| environment | string | - | yes | Environment name (dev, uat, prod) |
| vpc_cidr | string | - | yes | VPC CIDR block |
| azs | list(string) | - | yes | Availability zones |
| public_subnets | map(string) | - | yes | Public subnet CIDRs by AZ |
| private_subnets | map(string) | {} | no | Private subnet CIDRs by AZ |
| database_subnets | map(string) | {} | no | Database subnet CIDRs by AZ |
| enable_nat_gateway | bool | true | no | Enable NAT Gateway |
| enable_dns_support | bool | true | no | Enable DNS support |
| enable_dns_hostnames | bool | true | no | Enable DNS hostnames |
| tags | map(string) | {} | no | Additional resource tags |

## Module Outputs

| Output | Description |
|--------|-------------|
| vpc_id | VPC ID |
| vpc_cidr | VPC CIDR block |
| public_subnet_ids | Public subnet IDs by AZ |
| private_subnet_ids | Private subnet IDs by AZ |
| database_subnet_ids | Database subnet IDs by AZ |
| internet_gateway_id | Internet Gateway ID |
| nat_gateway_id | NAT Gateway ID |
| nat_gateway_eip | NAT Gateway public IP |
| public_route_table_id | Public route table ID |
| private_route_table_id | Private route table ID |
| default_security_group_id | Default security group ID |

## Deployment Guide

### Prerequisites

1. AWS Account with appropriate IAM permissions
2. Terraform >= 1.13.0
3. AWS CLI configured with credentials
4. S3 bucket for remote state (optional but recommended)

### Initialize and Deploy Dev Environment

```bash
cd terraform/Environments/Dev

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

### Initialize and Deploy UAT Environment

```bash
cd terraform/Environments/UAT

terraform init
terraform plan
terraform apply
```

### Initialize and Deploy Prod Environment

```bash
cd terraform/Environments/Prod

terraform init
terraform plan
terraform apply
```

## Local State Files

During testing, state files are created locally:
- `terraform.tfstate` - Current state
- `terraform.tfstate.backup` - Previous state backup

## Remote State Setup (Recommended for Production)

To use S3 backend instead of local state:

1. Create S3 bucket:
```bash
aws s3 mb s3://terraform-state-bucket-unique-name
aws s3api put-bucket-versioning --bucket terraform-state-bucket-unique-name --versioning-configuration Status=Enabled
```

2. Create DynamoDB table for locks:
```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

3. Update `providers.tf` in each environment with your bucket name

## Security Best Practices

1. **Default Security Group**: Only allows traffic from within VPC. Add specific security groups for resources.
2. **Private Subnets**: Use for sensitive workloads without direct internet exposure.
3. **NAT Gateway**: Ensures private resources can reach internet without inbound exposure.
4. **DNS**: Enabled by default for service discovery within VPC.
5. **VPC Flow Logs**: Consider enabling for traffic monitoring and troubleshooting.
6. **Network ACLs**: Review and implement if additional network segmentation needed.

## Cost Optimization

1. **NAT Gateway**: $0.045/hour + data transfer charges. Consider NAT instances for lower usage environments.
2. **Elastic IPs**: Unused EIPs incur charges. Monitor and remove unused IPs.
3. **VPC Endpoints**: For AWS service access (S3, DynamoDB) to reduce NAT Gateway traffic.
4. **Reserved Capacity**: For production, consider reserved NAT Gateway capacity.

## Troubleshooting

### Subnet connectivity issues
```bash
# Check route tables
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-xxxxx"

# Check security groups
aws ec2 describe-security-groups --filters "Name=vpc-id,Values=vpc-xxxxx"
```

### NAT Gateway issues
```bash
# Check NAT Gateway status
aws ec2 describe-nat-gateways --filters "Name=vpc-id,Values=vpc-xxxxx"

# Check elastic IP
aws ec2 describe-addresses --allocation-ids eipalloc-xxxxx
```

## Monitoring and Logging

### Enable VPC Flow Logs
```bash
aws ec2 create-flow-logs \
  --resource-type VPC \
  --resource-ids vpc-xxxxx \
  --traffic-type ALL \
  --log-destination-type cloud-watch-logs \
  --log-group-name /aws/vpc/flowlogs
```

## Cleanup

To destroy all resources:

```bash
cd terraform/Environments/Dev
terraform destroy

cd ../UAT
terraform destroy

cd ../Prod
terraform destroy
```

## Support and Contributing

For issues or improvements, please refer to the project's contribution guidelines.

## License

This module is provided as-is for infrastructure management.
