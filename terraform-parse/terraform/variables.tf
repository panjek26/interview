variable "aws_region" {
  description = "AWS region per environment"
  type        = map(string)
  default = {
    nonprod = "ap-northeast-1"
    prod    = "ap-northeast-1"
  }
}

variable "cluster_name" {
  description = "EKS cluster name per environment"
  type        = map(string)
  default = {
    nonprod = "tripla-messy-eks-nonprod"
    prod    = "tripla-messy-eks-prod"
  }
}

variable "vpc_id" {
  description = "VPC ID per environment"
  type        = map(string)
  default = {
    nonprod = "vpc-nonprod-1234556"
    prod    = "vpc-prod-1234556"
  }
}

variable "subnet_ids" {
  description = "Subnet IDs per environment"
  type        = map(list(string))
  default = {
    nonprod = ["subnet-nonprod-1", "subnet-nonprod-2"]
    prod    = ["subnet-prod-1", "subnet-prod-2"]
  }
}

variable "bucket_name" {
  description = "S3 bucket name per environment"
  type        = map(string)
  default = {
    nonprod = "tripla-static-assets-nonprod"
    prod    = "tripla-static-assets-prod"
  }
}

variable "environment" {
  description = "Environment name (nonprod or prod)"
  type        = map(string)
  default = {
    nonprod = "nonprod"
    prod    = "prod"
  }
}
