# ============================================================
# VPC CNI
# ============================================================

resource "aws_eks_addon" "vpc_cni" {

  cluster_name = aws_eks_cluster.this.name

  addon_name = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_eks_node_group.practice
  ]
}


# ============================================================
# COREDNS
# ============================================================

resource "aws_eks_addon" "coredns" {

  cluster_name = aws_eks_cluster.this.name

  addon_name = "coredns"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_eks_node_group.practice
  ]
}


# ============================================================
# KUBE PROXY
# ============================================================

resource "aws_eks_addon" "kube_proxy" {

  cluster_name = aws_eks_cluster.this.name

  addon_name = "kube-proxy"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_eks_node_group.practice
  ]
}


# ============================================================
# EKS POD IDENTITY AGENT
# ============================================================

resource "aws_eks_addon" "pod_identity_agent" {

  cluster_name = aws_eks_cluster.this.name

  addon_name = "eks-pod-identity-agent"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_eks_node_group.practice
  ]
}


# ============================================================
# EBS CSI DRIVER
# ============================================================

resource "aws_eks_addon" "ebs_csi" {

  cluster_name = aws_eks_cluster.this.name

  addon_name = "aws-ebs-csi-driver"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_eks_node_group.practice
  ]
}