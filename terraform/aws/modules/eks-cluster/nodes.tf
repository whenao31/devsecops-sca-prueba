resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "example"
  node_role_arn   = aws_iam_role.node_group_example.arn
  subnet_ids      = var.private_subnets_ids
  # subnet_ids      = var.public_subnets_ids

  instance_types = var.instance_types
  disk_size      = var.disk_size
  capacity_type  = "ON_DEMAND"
  scaling_config {
    desired_size = var.nodes_amount
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
    # aws_iam_role_policy_attachment.example-AmazonEBSCSIDriverPolicy,
  ]
}
