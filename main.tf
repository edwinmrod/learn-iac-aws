terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      Version = "~>3.27"
    }
  }

provider "aws" {
  region  = "east-us-1"
  access_key = ""
  secret_key = ""
}

resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-by-terraform"

  tags = {
    Name        = "iac terraform"
  }
}
