terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create the S3 bucket with static website hosting enabled
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name  # <-- Change this to your unique bucket name
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}


resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.website_bucket.bucket}/*"
        Principal = "*"
      }
    ]
  })
}
# Upload the index.html file
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  content = var.index_content
  content_type = "text/html"
}

# Upload an optional error.html file (optional but nice to have)
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "error.html"
  content = var.error_content
  content_type = "text/html"
}
