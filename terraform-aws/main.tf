terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  # We'll add remote backend later
  # backend "s3" {}
}

provider "aws" {
  region = var.region
}

# Get current AWS account info
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC for EKS
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "vpc-${var.project_name}-${var.environment}"
  })
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "igw-${var.project_name}-${var.environment}"
  })
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name                                           = "subnet-public-${count.index + 1}-${var.project_name}-${var.environment}"
    "kubernetes.io/role/elb"                       = "1"
    "kubernetes.io/cluster/eks-${var.project_name}-${var.environment}" = "shared"
  })
}

# Create private subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, {
    Name                                           = "subnet-private-${count.index + 1}-${var.project_name}-${var.environment}"
    "kubernetes.io/role/internal-elb"              = "1"
    "kubernetes.io/cluster/eks-${var.project_name}-${var.environment}" = "shared"
  })
}

# Create NAT Gateway (for private subnets)
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "eip-nat-${var.project_name}-${var.environment}"
  })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name = "nat-${var.project_name}-${var.environment}"
  })

  depends_on = [aws_internet_gateway.main]
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "rt-public-${var.project_name}-${var.environment}"
  })
}

# Route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "rt-private-${var.project_name}-${var.environment}"
  })
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Create ECR
module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

# Create EKS
module "eks" {
  source           = "./modules/eks"
  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = aws_vpc.main.id
  subnet_ids       = aws_subnet.private[*].id
  node_count       = var.eks_node_count
  node_size        = var.eks_node_size
  ecr_arn          = module.ecr.ecr_arn
  tags             = var.tags
}

# Create RDS PostgreSQL
module "postgresql" {
  source                 = "./modules/postgresql"
  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = aws_vpc.main.id
  subnet_ids             = aws_subnet.private[*].id
  db_name                = "taskmanager"
  master_username        = var.postgres_admin_username
  master_password        = var.postgres_admin_password
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  eks_security_group_id  = module.eks.cluster_security_group_id
  tags                   = local.common_tags
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
