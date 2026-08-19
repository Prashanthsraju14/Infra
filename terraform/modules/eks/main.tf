# ============================================================
# EKS CLUSTER
# ============================================================

resource "aws_eks_cluster" "this" {

  name = var.cluster_name

  role_arn = aws_iam_role.cluster.arn

  version = var.kubernetes_version


  # ==========================================================
  # EKS API AUTHENTICATION
  # ==========================================================

  access_config {

    authentication_mode = "API_AND_CONFIG_MAP"

  }


  # ==========================================================
  # NETWORKING
  # ==========================================================

  vpc_config {

    subnet_ids = var.private_subnet_ids

    endpoint_private_access = true

    endpoint_public_access = true
  }


  # ==========================================================
  # CONTROL PLANE LOGGING
  # ==========================================================

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]


  # ==========================================================
  # DEPENDENCY
  # ==========================================================

  depends_on = [

    aws_iam_role_policy_attachment.cluster_policy

  ]


  tags = var.tags
}