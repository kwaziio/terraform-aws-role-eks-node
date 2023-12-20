###########################
# Terraform Configuration #
###########################

terraform {
  required_version = ">= 1.6.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.21"
    }
  }
}

##############################
# AWS Provider Configuration #
##############################

provider "aws" {
  // DO NOT HARDCODE CREDENTIALS (Use Environment Variables)
}

##################################
# Example Terraform Module Usage #
##################################

module "terraform_aws_role_eks_node" {
  source = "../../"

  iam_role_enable_ebs_csi        = true
  iam_role_enable_efs_csi        = true
  iam_role_enable_full_s3_access = true
  iam_role_prefix                = "example-service-"

  resource_tags = {
    Environment = "examples"
    Feature     = "iam"
  }
}
