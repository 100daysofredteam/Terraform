variable "aws_region" {
  description = "AWS region to deploy resources"
}

variable "bucket_name" {
  description = "The bucket name to use for S3"
}

variable "index_content" {
    description = "Content for index.html"
}

variable "error_content" {
    description = "Content for error.html"
}
