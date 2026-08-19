# ============================================================
# EKS CLUSTER IAM ROLE
# ============================================================

resource "aws_iam_role" "cluster" {

  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}


# ============================================================
# EKS CLUSTER POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "cluster_policy" {

  role = aws_iam_role.cluster.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# ============================================================
# EKS NODE IAM ROLE
# ============================================================

resource "aws_iam_role" "node" {

  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}


# ============================================================
# EKS WORKER NODE POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "node_worker" {

  role = aws_iam_role.node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


# ============================================================
# EKS VPC CNI POLICY
# ============================================================
# Required by the AWS VPC CNI (aws-node) to manage
# ENIs and IP addresses for pods.
#
# For this practice cluster, the policy is attached
# directly to the node IAM role.
# ============================================================

resource "aws_iam_role_policy_attachment" "node_cni" {

  role = aws_iam_role.node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


# ============================================================
# ECR CONTAINER IMAGE PULL POLICY
# ============================================================

resource "aws_iam_role_policy_attachment" "node_ecr" {

  role = aws_iam_role.node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}