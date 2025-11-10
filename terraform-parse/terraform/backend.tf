terraform {
  backend "s3" {
    bucket         = "tripla-terraform-state"
    key            = "eks/${terraform.workspace}/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tripla-terraform-locks"
    encrypt        = true
  }
}
