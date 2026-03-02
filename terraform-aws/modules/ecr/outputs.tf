output "ecr_arn" {
  description = "The ECR repository ARN"
  value       = aws_ecr_repository.main.arn
}

output "repository_name" {
  description = "The ECR repository name"
  value       = aws_ecr_repository.main.name
}

output "repository_url" {
  description = "The ECR repository URL"
  value       = aws_ecr_repository.main.repository_url
}

output "registry_id" {
  description = "The ECR registry ID"
  value       = aws_ecr_repository.main.registry_id
}
