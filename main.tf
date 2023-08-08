terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      Version = "~>3.27"
    }
  }

provider "aws" {
  version = "~>3.0"
  region  = "east-us-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-by-terraform"

  tags = {
    Name        = "iac terraform"
  }
}
