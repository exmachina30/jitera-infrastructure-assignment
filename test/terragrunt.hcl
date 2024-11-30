# Configure Terraform module for the EKS cluster
terraform {
  source = "../../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  cluster_name = "prod-eks-cluster"
  region       = "us-east-2"
  vpc_id       = dependency.vpc.outputs.vpc_id
  subnet_ids   = dependency.vpc.outputs.all_subnet_ids
  
  default_desired_capacity = 2
  default_max_capacity     = 3
  default_min_capacity     = 1
  default_instance_type    = "t3.large"
}

include {
  path = find_in_parent_folders()
}
