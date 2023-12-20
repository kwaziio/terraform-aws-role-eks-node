###############################################################
# AWS Identity and Access Management (IAM) Role Configuration #
###############################################################

variable "iam_role_enable_ebs_csi" {
  default     = false
  description = "'true' if EKS EBS CSI Driver Support Will be Enabled"
  type        = bool
}

variable "iam_role_enable_efs_csi" {
  default     = false
  description = "'true' if EKS EFS CSI Driver Support Will be Enabled"
  type        = bool
}

variable "iam_role_enable_full_s3_access" {
  default     = false
  description = "'true' if Full S3 Access Should be Granted (Managed Policy)"
  type        = bool
}

variable "iam_role_name" {
  default     = "eks-node"
  description = "Name to Assign to the Created AWS IAM Role"
  type        = string
}

variable "iam_role_permissions_boundary" {
  default     = null
  description = "Permissions Boundary to Assign to the Created AWS IAM Role (Optional)"
  type        = string
}

variable "iam_role_prefix" {
  default     = null
  description = "Name Prefix to Assign to the Created AWS IAM Role"
  type        = string
}

##################################
# Created Resource Configuration #
##################################

variable "resource_tags" {
  default     = {}
  description = "Map of AWS Resource Tags to Assign to All Created Resources"
  type        = map(string)
}
