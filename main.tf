#######################################################################
# Retrieves AWS Managed IAM Policy for Required EBS CSI Driver Access #
#######################################################################

data "aws_iam_policy" "ebs_csi_driver" {
  count = var.iam_role_enable_ebs_csi ? 1 : 0
  name  = "AmazonEBSCSIDriverPolicy"
}

############################################################################
# Retrieves AWS Managed IAM Policy for EC2 Container Registry (ECR) Access #
############################################################################

data "aws_iam_policy" "ecr_ro" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

#######################################################################
# Retrieves AWS Managed IAM Policy for Required EFS CSI Driver Access #
#######################################################################

data "aws_iam_policy" "efs_csi_driver" {
  count = var.iam_role_enable_efs_csi ? 1 : 0
  name  = "AmazonEFSCSIDriverPolicy"
}

#####################################################################################
# Retrieves AWS Managed IAM Policy for EKS Container Network Interface (CNI) Access #
#####################################################################################

data "aws_iam_policy" "eks_cni" {
  name = "AmazonEKS_CNI_Policy"
}

###############################################################
# Retrieves AWS Managed IAM Policy for EKS Worker Node Access #
###############################################################

data "aws_iam_policy" "eks_worker_node" {
  name = "AmazonEKSWorkerNodePolicy"
}

#######################################################
# Retrieves AWS Managed IAM Policy for Full S3 Access #
#######################################################

data "aws_iam_policy" "s3_full_access" {
  count = var.iam_role_enable_full_s3_access ? 1 : 0
  name  = "AmazonS3FullAccess"
}

#######################################################################################
# Creates AWS Identity and Access Management (IAM) Assume Role Policy for EKS Node(s) #
#######################################################################################

data "aws_iam_policy_document" "assume_role_ec2" {
  version = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

#########################################################################
# Creates AWS Identity and Access Management (IAM) Role for EKS Node(s) #
#########################################################################

resource "aws_iam_role" "eks_node" {
  assume_role_policy   = data.aws_iam_policy_document.assume_role_ec2.json
  description          = "AWS IAM Role for Granting Access Permissions to EKS Nodes"
  name                 = "${var.iam_role_prefix}${var.iam_role_name}"
  permissions_boundary = var.iam_role_permissions_boundary
  tags                 = var.resource_tags
}

#########################################################
# Attaches Policies to the AWS IAM Role for EKS Node(s) #
#########################################################

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  count      = var.iam_role_enable_ebs_csi ? 1 : 0
  policy_arn = one(data.aws_iam_policy.ebs_csi_driver).arn
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "efs_csi_driver" {
  count      = var.iam_role_enable_efs_csi ? 1 : 0
  policy_arn = one(data.aws_iam_policy.efs_csi_driver).arn
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "ecr_ro" {
  policy_arn = data.aws_iam_policy.ecr_ro.arn
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  policy_arn = data.aws_iam_policy.eks_cni.arn
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  policy_arn = data.aws_iam_policy.eks_worker_node.arn
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  count      = var.iam_role_enable_full_s3_access ? 1 : 0
  policy_arn = one(data.aws_iam_policy.s3_full_access).arn
  role       = aws_iam_role.eks_node.name
}
