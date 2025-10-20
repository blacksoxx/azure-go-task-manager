
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "server_name" {
  description = "The name of the PostgreSQL flexible server"
  type        = string
}

variable "postgres_version" {
  description = "The PostgreSQL version"
  type        = string
  default     = "13"
}

variable "administrator_login" {
  description = "PostgreSQL admin username"
  type        = string
  default     = "postgresadmin"
}

variable "administrator_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "The SKU name for the PostgreSQL flexible server"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "The storage size in MB for the PostgreSQL flexible server"
  type        = number
  default     = 32768
}

variable "backup_retention_days" {
  description = "Backup retention days for the PostgreSQL server"
  type        = number
  default     = 7
}

variable "zone" {
  description = "The availability zone for the server"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "enable_high_availability" {
  description = "Enable high availability for the PostgreSQL server"
  type        = bool
  default     = false
}

variable "standby_availability_zone" {
  description = "The standby availability zone for high availability"
  type        = string
  default     = "1"
}

# Project and environment variables (if used for naming)
variable "project_name" {
  description = "The project name"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "database_name" {
  description = "The name of the database to create"
  type        = string
  default     = "taskmanager"
}