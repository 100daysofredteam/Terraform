variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  validation {
    condition     = length(var.bucket_name) > 0
    error_message = "The bucket_name variable must not be empty."
  }
}

variable "file_name_key" {
  description = "Name of the file"
  type        = string
  validation {
    condition     = length(var.file_name_key) > 0
    error_message = "The file_name_key variable must not be empty."
  }
}


variable "file_content" {
  description = "Content of the file"
  type        = string
  validation {
    condition     = length(var.file_content) > 0
    error_message = "The file_content variable must not be empty."
  }
}