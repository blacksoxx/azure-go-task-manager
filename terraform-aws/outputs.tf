output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "ecr_repository_url" {
  description = "The ECR repository URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "The ECR repository name"
  value       = module.ecr.repository_name
}

output "eks_cluster_name" {
  description = "The EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "postgresql_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = module.postgresql.endpoint
}

output "postgresql_database_name" {
  description = "PostgreSQL database name"
  value       = module.postgresql.database_name
}
