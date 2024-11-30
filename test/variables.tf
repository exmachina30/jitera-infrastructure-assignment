variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.25"  # Example version, adjust as needed
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to deploy the EKS cluster into"
  type        = list(string)
  default     = [] # Default to empty if dynamically fetching
}

variable "default_desired_capacity" {
  description = "Desired capacity for the default node group"
  type        = number
  default     = 2
}

variable "default_max_capacity" {
  description = "Maximum capacity for the default node group"
  type        = number
  default     = 3
}

variable "default_min_capacity" {
  description = "Minimum capacity for the default node group"
  type        = number
  default     = 1
}

variable "default_instance_type" {
  description = "Instance type for the default node group"
  type        = string
  default     = "t3.medium"
}

variable "kubelet_args" {
  description = "Additional arguments to pass to the kubelet (e.g., '--max-pods')"
  type        = string
  default     = "--node-labels=env=prod,role=worker"  # Adjust default as necessary
}
