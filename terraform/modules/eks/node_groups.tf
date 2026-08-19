# ============================================================
# EKS MANAGED NODE GROUP
# ============================================================

resource "aws_eks_node_group" "practice" {

  cluster_name = aws_eks_cluster.this.name

  node_group_name = "${var.cluster_name}-node-group"

  node_role_arn = aws_iam_role.node.arn


  # ==========================================================
  # ONLY PRIVATE APPLICATION SUBNETS
  # ==========================================================

  subnet_ids = var.private_subnet_ids


  # ==========================================================
  # INSTANCE
  # ==========================================================

  instance_types = [
    var.node_instance_type
  ]

  capacity_type = "ON_DEMAND"


  # ==========================================================
  # AUTO SCALING
  # ==========================================================

  scaling_config {

    min_size = var.node_min_size

    desired_size = var.node_desired_size

    max_size = var.node_max_size
  }


  # ==========================================================
  # ROOT DISK
  # ==========================================================

  disk_size = var.node_disk_size


  # ==========================================================
  # KUBERNETES LABELS
  # ==========================================================

  labels = {

    environment = var.environment

    nodegroup = "practice"

  }


  # ==========================================================
  # NODE UPDATE CONFIGURATION
  # ==========================================================

  update_config {

    max_unavailable = 1

  }


  # ==========================================================
  # DEPENDENCIES
  # ==========================================================

  depends_on = [

    aws_iam_role_policy_attachment.node_worker,

    aws_iam_role_policy_attachment.node_ecr

  ]


  tags = var.tags
}