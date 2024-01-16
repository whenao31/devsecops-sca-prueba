data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "eks-cluster-example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}


resource "aws_iam_role_policy_attachment" "example-eks-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.example.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.example.name
}

# ******************************IAM ROLE for EKS Node Group******************************
resource "aws_iam_role" "node_group_example" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy" "node_group_ebs_policy" {
  name = "node-group-ebs-policy"
  role = aws_iam_role.node_group_example.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "MinimalEBSKMSCreateandAttach",
        "Effect": "Allow",
        "Action": [
            "ec2:CreateVolume",
            "ec2:DeleteVolume",
            "ec2:DetachVolume",
            "ec2:AttachVolume",
            "ec2:DescribeInstances",
            "ec2:CreateTags",
            "ec2:DeleteTags",
            "ec2:DescribeTags",
            "ec2:DescribeVolumes"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group_example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group_example.name
}

resource "aws_iam_role_policy_attachment" "example_node_group-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.node_group_example.name
}

################################################################################
###            EBS SCI

data "aws_caller_identity" "current" {}

# resource "aws_iam_role" "ebs_role" {
#   name = "ebs-role" 

resource "aws_iam_role" "ebs_role" {
  name = "ebs-role" 

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${aws_iam_openid_connect_provider.eks.id}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            format("%s:aud", join("/", slice(split("/", aws_iam_openid_connect_provider.eks.id), 1, length(split("/", aws_iam_openid_connect_provider.eks.id))))): "sts.amazonaws.com",
            format("%s:sub", join("/", slice(split("/", aws_iam_openid_connect_provider.eks.id), 1, length(split("/", aws_iam_openid_connect_provider.eks.id))))): "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "kms_ebs_role_policy" {
  name = "kms-ebs-role-policy"
  role = aws_iam_role.ebs_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "MinimalEBSKMSCreateandAttach",
        "Effect": "Allow",
        "Action": [
            "kms:Decrypt",
            "kms:GenerateDataKeyWithoutPlaintext",
            "kms:CreateGrant"
        ],
        "Resource": "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "example-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_role.name
}

