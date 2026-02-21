terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.38"
    }
  }
}

provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = var.aws_role_arn
  }
}
