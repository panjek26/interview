terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  env = terraform.workspace == "prod" ? "production" : "non-production"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0"

  cluster_name    = "${terraform.workspace}-${var.cluster_name}"
  cluster_version = "1.25"
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.medium"]
    }
  }

  tags = {
    Environment = local.env
  }
}

resource "aws_s3_bucket" "static_assets" {
  bucket = "${terraform.workspace}-${var.bucket_name}"
  acl    = var.acl

  tags = {
    Env = local.env
  }
}
