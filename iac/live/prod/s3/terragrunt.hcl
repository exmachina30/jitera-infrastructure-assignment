terraform {
  source = "../../../modules/s3"
}

inputs = {
  bucket_name   = "bucket-worker-prod"
}

include {
  path = find_in_parent_folders()
}