variable "bucket_name" {
  description = "S3 bucket name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "The bucket name must contain only lowercase alphanumeric characters and hyphens, and be between 3 and 63 characters."
  }
}
