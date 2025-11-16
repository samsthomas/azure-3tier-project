resource "azurerm_mssql_server" "sql" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  tags = var.tags
}

resource "azurerm_mssql_database" "db" {
  name      = var.database_name
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "Basic"

  tags = var.tags
}

resource "azurerm_mssql_firewall_rule" "allow_app_subnet" {
  name             = "allow-app-subnet"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = cidrhost(var.app_subnet_prefix, 1)
  end_ip_address   = cidrhost(var.app_subnet_prefix, 254)

}

module "diagnostics_sql" {
  source = "../../modules/diagnostics"

  resource_name              = azurerm_mssql_server.sql.name
  resource_id                = azurerm_mssql_server.sql.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories = [
    "SQLSecurityAuditEvents",
    "DevOpsOperationsAudit",
    "QueryStoreRuntimeStatistics",
  ]

  metric_categories = [
    "AllMetrics"
  ]
}