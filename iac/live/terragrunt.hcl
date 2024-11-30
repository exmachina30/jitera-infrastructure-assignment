remote_state {
  backend = "s3"
  config = {
    bucket         = "new-main-prod-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
