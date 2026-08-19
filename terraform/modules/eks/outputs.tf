# ============================================================
# EKS CLUSTER
# ============================================================

output "cluster_name" {

  value = aws_eks_cluster.this.name
}


output "cluster_endpoint" {

  value = aws_eks_cluster.this.endpoint
}


output "cluster_arn" {

  value = aws_eks_cluster.this.arn
}


output "cluster_version" {

  value = aws_eks_cluster.this.version
}


# ============================================================
# IAM
# ============================================================

output "cluster_role_arn" {

  value = aws_iam_role.cluster.arn
}


output "node_role_arn" {

  value = aws_iam_role.node.arn
}


# ============================================================
# NODE GROUP
# ============================================================

output "node_group_name" {

  value = aws_eks_node_group.practice.node_group_name
}


output "node_group_arn" {

  value = aws_eks_node_group.practice.arn
}