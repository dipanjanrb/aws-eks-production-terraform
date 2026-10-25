output "kms_key_arn" {
  description = "ARN of KMS key used for EKS Secrets encryption"
  value       = aws_kms_key.eks_secrets.arn
}

output "cluster_role_arn" {
  description = "IAM Role ARN for the EKS Cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_role_arn" {
  description = "IAM Role ARN for EKS Managed Node Groups"
  value       = aws_iam_role.eks_node_role.arn
}
