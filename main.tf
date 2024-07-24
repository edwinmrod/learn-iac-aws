terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "access_key" {
  description = "AWS access key"
}

variable "secret_key" {
  description = "AWS secret key"
}
resource "aws_s3_bucket" "bucket_frontend" {
  bucket = "curso-s3-cloudfront"

  tags = {
    Name = "iac terraform ed"
  }
}

resource "aws_cloudfront_distribution" "cloudfront_main" {
  origin {
    domain_name              = aws_s3_bucket.bucket_frontend.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
    origin_id                = aws_s3_bucket.bucket_frontend.bucket
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront from iac"
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.bucket_frontend.bucket

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["CO"]
    }
  }

  tags = {
    Name = "iac terraform ed"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }


}
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "s3-cloudfront-access-control_poc"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


data "aws_iam_policy_document" "cloudfront_oac_access" {
  statement {
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket_frontend.arn}/*"]
    condition {
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.cloudfront_main.arn]
      variable = "AWS:SourceArn"
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_frontend" {
  bucket = aws_s3_bucket.bucket_frontend.id
  policy = data.aws_iam_policy_document.cloudfront_oac_access.json
}
