variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS"
  type        = list(string)
}

variable "project_name" {
  description = "The project name"
  type        = string
  default     = "taskmanager"
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "node_count" {
  description = "Number of EKS nodes"
  type        = number
  default     = 2
}

variable "node_size" {
  description = "Instance type for EKS nodes"
  type        = string
  default     = "t3.small"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS (EKS only allows upgrading one minor version at a time)"
  type        = string
  default     = "1.29"
}

variable "ecr_arn" {
  description = "The ECR repository ARN"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
