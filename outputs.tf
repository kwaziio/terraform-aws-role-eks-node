####################################################################
# Provides Information About Role Resources Created by this Module #
####################################################################

output "id" {
  description = "ARN Assigned to the AWS IAM Role Created by this Module"
  value       = aws_iam_role.eks_node.arn
}

output "info" {
  description = "General Information About Resources Created by this Module (Unstable)"

  value = {
    unique_id = aws_iam_role.eks_node.arn

    attached_policies = [
      aws_iam_role_policy_attachment.ecr_ro.policy_arn,
      aws_iam_role_policy_attachment.eks_cni.policy_arn,
      aws_iam_role_policy_attachment.eks_worker_node.policy_arn,
      
      "${var.iam_role_enable_ebs_csi ? one(aws_iam_role_policy_attachment.ebs_csi_driver).policy_arn : null}",
      "${var.iam_role_enable_efs_csi ? one(aws_iam_role_policy_attachment.efs_csi_driver).policy_arn : null}",
      "${var.iam_role_enable_full_s3_access ? one(aws_iam_role_policy_attachment.s3_full_access).policy_arn : null}",
    ]
  }
}

output "name" {
  description = "Name Assigned to the AWS IAM Role Created by this Module"
  value       = aws_iam_role.eks_node.name
}

output "tags" {
  description = "Map of Tags Assigned to the AWS IAM Role Created by this Module"
  value       = aws_iam_role.eks_node.tags_all
}
