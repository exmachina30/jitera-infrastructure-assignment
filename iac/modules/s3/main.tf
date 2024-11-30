terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "default" {
  bucket = replace(lower(var.bucket_name), "_", "-")
  acl    = "private"
  versioning {
    enabled = true
  }
  
  #lifecycle {
  #  prevent_destroy = true
  #}
}

# Adding Glacier storage class for cost-effective long-term storage
resource "aws_s3_bucket_intelligent_tiering_configuration" "default" {
  bucket = aws_s3_bucket.default.id
  name   = "ArchiveEntireBucket"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 125
  }
}

