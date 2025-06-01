resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_object" "this" {
  bucket  = aws_s3_bucket.this.id
  key     = var.file_name_key
  content = var.file_content
}
