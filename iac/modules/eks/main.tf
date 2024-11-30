terraform {
  backend "s3" {}
}

resource "aws_key_pair" "eks_key_pair" {
  key_name   = "eks-node-key"
  public_key = file("~/.ssh/id_rsa.pub")  
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  eks_managed_node_groups = {
    nodegroup_1 = {
      desired_capacity = var.default_desired_capacity
      max_capacity     = var.default_max_capacity
      min_capacity     = var.default_min_capacity
      instance_type    = var.default_instance_type
      ami_type         = "AL2_x86_64"  
      node_role_arn    = aws_iam_role.eks_worker_role.arn 
      cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
      vpc_security_group_ids            = [module.eks.node_security_group_id]
      key_name         = aws_key_pair.eks_key_pair.key_name
      user_data = base64encode(<<-EOT
#!/bin/bash
/etc/eks/bootstrap.sh --apiserver-endpoint ${module.eks.cluster_endpoint} --b64-cluster-ca ${module.eks.cluster_certificate_authority_data} --kubelet-extra-args ${var.kubelet_args}
EOT
      )
    }

    nodegroup_2 = {
      desired_capacity = var.default_desired_capacity
      max_capacity     = var.default_max_capacity
      min_capacity     = var.default_min_capacity
      instance_type    = var.default_instance_type
      ami_type         = "AL2_x86_64"  
      node_role_arn    = aws_iam_role.eks_worker_role.arn  
      cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
      vpc_security_group_ids            = [module.eks.node_security_group_id]
      key_name         = aws_key_pair.eks_key_pair.key_name
      user_data = base64encode(<<-EOT
#!/bin/bash
/etc/eks/bootstrap.sh --apiserver-endpoint ${module.eks.cluster_endpoint} --b64-cluster-ca ${module.eks.cluster_certificate_authority_data} --kubelet-extra-args ${var.kubelet_args}
EOT
      )
    }
  }

  bootstrap_self_managed_addons = true
  enable_cluster_creator_admin_permissions = true
}

# Define the IAM policy document for the worker role
data "aws_iam_policy_document" "eks_worker_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create IAM Role for EKS Worker Nodes
resource "aws_iam_role" "eks_worker_role" {
  name               = "eks_worker_role"
  assume_role_policy = data.aws_iam_policy_document.eks_worker_assume_role_policy.json
}

# Attach policies to the IAM role for EKS Worker Nodes
resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_ecr_policy" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_worker_cni_policy" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "eks_key_pair_name" {
  description = "The name of the key pair used by the EC2 instances in the EKS node group"
  value       = aws_key_pair.eks_key_pair.key_name
}

output "eks_key_pair_fingerprint" {
  description = "The fingerprint of the created EC2 key pair"
  value       = aws_key_pair.eks_key_pair.fingerprint
}
