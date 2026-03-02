# AWS Authentication Variables
variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
  default     = null
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
  default     = null
}

# Project Configuration
variable "project_name" {
  description = "The project name"
  type        = string
  default     = "taskmanager"
}

variable "environment" {
  description = "The environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "eu-west-3"  # Paris region (equivalent to Azure francecentral)
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# EKS Configuration
variable "eks_node_count" {
  description = "Number of EKS nodes"
  type        = number
  default     = 2
}

variable "eks_node_size" {
  description = "Instance type for EKS nodes"
  type        = string
  default     = "t3.small"  # Equivalent to Azure Standard_B2s
}

# RDS Configuration
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"  # Equivalent to Azure B_Standard_B1ms
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 32  # Equivalent to 32768 MB in Azure
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "TaskManager"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# PostgreSQL Configuration
variable "postgres_admin_username" {
  description = "PostgreSQL admin username"
  type        = string
  default     = "postgresadmin"
}

variable "postgres_admin_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}
