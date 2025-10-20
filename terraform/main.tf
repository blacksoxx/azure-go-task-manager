terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
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
  # backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Get current client configuration
data "azurerm_client_config" "current" {}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = var.tags
}

# Create ACR
module "acr" {
  source              = "./modules/acr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
  tags                = var.tags
}

# Create AKS
module "aks" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
  node_count          = var.aks_node_count
  node_size           = var.aks_node_size
  acr_id              = module.acr.acr_id
  tags                = var.tags
}

# main.tf
module "postgresql" {
  source                 = "./modules/postgresql"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  server_name            = "psql-${var.project_name}-${var.environment}"
  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password
  database_name          = "taskmanager"
  project_name           = var.project_name
  environment            = var.environment
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  # Don't set zone for burstable SKU to avoid conflicts
  # zone                   = "2" 
  enable_high_availability = false  # Explicitly false for burstable SKU
  tags                   = local.common_tags
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}