output "eks_cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "The name of the EKS cluster."
}

output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "The endpoint of the EKS cluster API server."
}

output "eks_cluster_ca" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "The base64-encoded certificate authority data for the cluster."
}

