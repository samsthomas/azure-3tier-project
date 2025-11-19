output "sql_server_name" {
  value = azurerm_mssql_server.sql.name
}

output "sql_database_name" {
  value = azurerm_mssql_database.db.name
}

output "sql_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.db.name};User ID=${var.admin_username};Password=${var.admin_password};Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"



}
