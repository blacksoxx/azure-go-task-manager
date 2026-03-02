output "server_fqdn" {
  description = "PostgreSQL server FQDN"
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "database_name" {
  description = "Database name"
  value       = azurerm_postgresql_flexible_server_database.main.name
}

output "administrator_login" {
  description = "PostgreSQL admin username"
  value       = var.administrator_login  # Changed to match resource
  sensitive   = true
}

output "administrator_password" {
  description = "PostgreSQL admin password"
  value       = var.administrator_password  # Changed to match resource
  sensitive   = true
}