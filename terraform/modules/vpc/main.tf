# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "this" {

  cidr_block = var.vpc_cidr

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-vpc"
    }
  )
}


# ============================================================
# INTERNET GATEWAY
# ============================================================

resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-igw"
    }
  )
}


# ============================================================
# PUBLIC SUBNETS
# ============================================================

resource "aws_subnet" "public" {

  for_each = local.public_subnets

  vpc_id = aws_vpc.this.id

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-public-${each.key}"

      # EKS external load balancers
      "kubernetes.io/role/elb" = "1"
    }
  )
}


# ============================================================
# PRIVATE APPLICATION SUBNETS
# ============================================================

resource "aws_subnet" "private" {

  for_each = local.private_subnets

  vpc_id = aws_vpc.this.id

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-private-${each.key}"

      # EKS internal load balancers
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}


# ============================================================
# DATABASE SUBNETS
# ============================================================

resource "aws_subnet" "database" {

  for_each = local.database_subnets

  vpc_id = aws_vpc.this.id

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-database-${each.key}"
    }
  )
}


# ============================================================
# PUBLIC ROUTE TABLE
# ============================================================

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-public-rt"
    }
  )
}


# ============================================================
# PUBLIC -> INTERNET
# ============================================================

resource "aws_route" "public_internet" {

  route_table_id = aws_route_table.public.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.this.id
}


# ============================================================
# PUBLIC ROUTE TABLE ASSOCIATIONS
# ============================================================

resource "aws_route_table_association" "public" {

  for_each = aws_subnet.public

  subnet_id = each.value.id

  route_table_id = aws_route_table.public.id
}


# ============================================================
# NAT ELASTIC IP
# ============================================================

resource "aws_eip" "nat" {

  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-nat-eip"
    }
  )
}


# ============================================================
# ONE NAT GATEWAY
#
# Created inside first public subnet
# ============================================================

resource "aws_nat_gateway" "this" {

  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id

  subnet_id = aws_subnet.public[local.nat_az].id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-nat"
    }
  )

  depends_on = [
    aws_internet_gateway.this
  ]
}


# ============================================================
# PRIVATE APPLICATION ROUTE TABLES
#
# One route table per AZ
# Both point to the SAME NAT Gateway
# ============================================================

resource "aws_route_table" "private" {

  for_each = toset(var.azs)

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-private-rt-${each.key}"
    }
  )
}


# ============================================================
# PRIVATE -> ONE NAT GATEWAY
# ============================================================

resource "aws_route" "private_nat" {

  for_each = var.enable_nat_gateway ? toset(var.azs) : toset([])

  route_table_id = aws_route_table.private[each.key].id

  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.this[0].id
}


# ============================================================
# PRIVATE APPLICATION SUBNET ASSOCIATIONS
# ============================================================

resource "aws_route_table_association" "private" {

  for_each = aws_subnet.private

  subnet_id = each.value.id

  route_table_id = aws_route_table.private[each.key].id
}


# ============================================================
# DATABASE SUBNET ASSOCIATIONS
#
# Database subnets also use the SAME NAT route tables.
# Therefore they can download packages / updates.
# ============================================================

resource "aws_route_table_association" "database" {

  for_each = aws_subnet.database

  subnet_id = each.value.id

  route_table_id = aws_route_table.private[each.key].id
}


# ============================================================
# CLOUDWATCH LOG GROUP
# ============================================================

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {

  count = var.enable_flow_logs ? 1 : 0

  name = "/aws/vpc/${var.name}-${var.environment}"

  retention_in_days = var.flow_log_retention_days

  tags = local.common_tags
}


# ============================================================
# FLOW LOG IAM ROLE
# ============================================================

resource "aws_iam_role" "flow_logs" {

  count = var.enable_flow_logs ? 1 : 0

  name = "${var.name}-${var.environment}-vpc-flow-logs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}


# ============================================================
# FLOW LOG IAM POLICY
# ============================================================

resource "aws_iam_role_policy" "flow_logs" {

  count = var.enable_flow_logs ? 1 : 0

  name = "${var.name}-${var.environment}-vpc-flow-logs"

  role = aws_iam_role.flow_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "${aws_cloudwatch_log_group.vpc_flow_logs[0].arn}:*"
      }
    ]
  })
}


# ============================================================
# VPC FLOW LOG
# ============================================================

resource "aws_flow_log" "this" {

  count = var.enable_flow_logs ? 1 : 0

  vpc_id = aws_vpc.this.id

  traffic_type = "ALL"

  iam_role_arn = aws_iam_role.flow_logs[0].arn

  log_destination = aws_cloudwatch_log_group.vpc_flow_logs[0].arn

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.environment}-flow-logs"
    }
  )
}