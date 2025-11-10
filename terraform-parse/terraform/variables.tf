variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "cluster_name" {
  type    = string
  default = "tripla-messy-eks"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the EKS cluster will be deployed."
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs for the EKS cluster."
}

variable "bucket_name" {
  type    = string
  default = "tripla-static-assets"
}

variable "acl" {
  type    = string
  default = "private"
}

variable "environment" {
  type        = string
  description = "Environment name, e.g., dev, staging, prod"
}
