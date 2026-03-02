output "endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "address" {
  description = "PostgreSQL RDS address (hostname only)"
  value       = aws_db_instance.postgres.address
}

output "port" {
  description = "PostgreSQL RDS port"
  value       = aws_db_instance.postgres.port
}

output "database_name" {
  description = "Database name"
  value       = aws_db_instance.postgres.db_name
}

output "master_username" {
  description = "PostgreSQL master username"
  value       = var.master_username
  sensitive   = true
}

output "master_password" {
  description = "PostgreSQL master password"
  value       = var.master_password
  sensitive   = true
}

output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.postgres.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.postgres.arn
}

output "security_group_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds.id
}
