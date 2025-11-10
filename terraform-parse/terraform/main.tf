locals {
  env = terraform.workspace == "prod" ? "prod" : "non-production"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.1.0"

  cluster_name    = "${terraform.workspace}-${lookup(var.cluster_name, terraform.workspace)}"
  cluster_version = "1.25"
  vpc_id          = lookup(var.vpc_id, terraform.workspace)
  subnet_ids      = lookup(var.subnet_ids, terraform.workspace)

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
  bucket = "${terraform.workspace}-${lookup(var.bucket_name, terraform.workspace)}"

  tags = {
    Env = local.env
  }
}

resource "aws_s3_bucket_acl" "static_assets_acl" {
  bucket = aws_s3_bucket.static_assets.id
  acl    = "private"
}
