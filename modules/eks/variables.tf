variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes control plane version"
  type        = string
  default     = "1.29"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS control plane and worker nodes (private subnets)"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM Role ARN for the EKS Cluster"
  type        = string
}

variable "node_role_arn" {
  description = "IAM Role ARN for EKS Managed Node Groups"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS Key ARN for EKS Secrets envelope encryption"
  type        = string
}

variable "node_instance_types" {
  description = "Instance types for the default managed node group"
  type        = list(string)
  default     = ["m6i.xlarge", "m5.xlarge"]
}

variable "desired_nodes" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 3
}

variable "min_nodes" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 3
}

variable "max_nodes" {
  description = "Maximum number of worker nodes for auto-scaling"
  type        = number
  default     = 10
}
