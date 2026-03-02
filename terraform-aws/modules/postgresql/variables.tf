variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS"
  type        = list(string)
}

variable "project_name" {
  description = "The project name"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "taskmanager"
}

variable "postgres_version" {
  description = "The PostgreSQL version"
  type        = string
  default     = "15"
}

variable "master_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "postgresadmin"
}

variable "master_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "The RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 32
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage in GB for autoscaling"
  type        = number
  default     = 100
}

variable "backup_retention_days" {
  description = "Backup retention days for the PostgreSQL instance"
  type        = number
  default     = 7
}

variable "enable_multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting the database"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_performance_insights" {
  description = "Enable Performance Insights"
  type        = bool
  default     = false
}

variable "eks_security_group_id" {
  description = "Security group ID of the EKS cluster for database access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
