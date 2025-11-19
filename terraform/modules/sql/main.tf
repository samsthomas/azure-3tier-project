resource "azurerm_mssql_server" "sql" {
  name                          = var.sql_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.admin_username
  administrator_login_password  = var.admin_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_mssql_database" "db" {
  name      = var.database_name
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "Basic"

  tags = var.tags
}

# resource "azurerm_mssql_firewall_rule" "allow_app_subnet" {
#   name             = "allow-app-subnet"
#   server_id        = azurerm_mssql_server.sql.id
#   start_ip_address = cidrhost(var.app_subnet_prefix, 1)
#   end_ip_address   = cidrhost(var.app_subnet_prefix, 254)

# }

# resource "azurerm_mssql_firewall_rule" "allow_azure" {
#   name             = "AllowAllAzureServices"
#   server_id        = azurerm_mssql_server.sql.id
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "0.0.0.0"
# }

resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name

  tags = var.tags

}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_vnet_link" {
  name                  = "${var.sql_server_name}-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id

  registration_enabled = false

}

resource "azurerm_private_endpoint" "sql_pe" {
  name                = "${var.sql_server_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.backend_subnet_id

  private_service_connection {
    name                           = "${var.sql_server_name}-pe-conn"
    private_connection_resource_id = azurerm_mssql_server.sql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

}

module "diagnostics_sql" {
  source = "../../modules/diagnostics"

  resource_name              = azurerm_mssql_server.sql.name
  resource_id                = azurerm_mssql_server.sql.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories    = var.log_categories
  metric_categories = var.metric_categories

}