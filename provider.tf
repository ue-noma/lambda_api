provider "aws" {
  region = "ap-northeast-1"
}

provider "archive" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
  }
}
