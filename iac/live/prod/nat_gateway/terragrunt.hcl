terraform {
  source = "../../../modules/nat_gateway"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  public_subnet_id = dependency.vpc.outputs.public_subnet_id
  name             = "prod-nat-gateway"
}

include {
  path = find_in_parent_folders()
}

