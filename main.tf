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
