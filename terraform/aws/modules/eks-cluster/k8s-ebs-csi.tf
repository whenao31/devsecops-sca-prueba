# resource "aws_eks_addon" "ebs_csi" {
#   cluster_name = aws_eks_cluster.example.name
#   addon_name   = "aws-ebs-csi-driver"
#   service_account_role_arn = aws_iam_role.ebs_role.arn
# }