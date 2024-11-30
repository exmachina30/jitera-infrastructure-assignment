terraform {
  backend "s3" {
    bucket         = "main-prod-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-2"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.31"
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 2
      instance_type    = "t3.large"
      ami_type         = "AL2_x86_64"  # Specify the correct AMI type
      node_role_arn    = aws_iam_role.eks_worker_role.arn  # Ensure IAM role is attached properly
      cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
      vpc_security_group_ids            = [module.eks.node_security_group_id]
      user_data = base64encode(<<-EOT
#!/bin/bash
/etc/eks/bootstrap.sh --apiserver-endpoint ${module.eks.cluster_endpoint} --b64-cluster-ca ${module.eks.cluster_certificate_authority_data} --kubelet-extra-args ${var.kubelet_args}
EOT
      )
    }
  }

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
