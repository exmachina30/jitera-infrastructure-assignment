terraform {
  source = "../../../modules/vpc"
}

inputs = {
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.1.0/24"
  private_subnet_cidr   = "10.0.2.0/24"
  private_subnet_cidr_2 = "10.0.3.0/24"
  availability_zone     = "us-east-2a"
  availability_zone_2   = "us-east-2b"
  name                  = "prod-vpc"
}

include {
  path = find_in_parent_folders()
}