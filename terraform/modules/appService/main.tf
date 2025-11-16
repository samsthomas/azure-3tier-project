resource "azurerm_service_plan" "plan" {
  name                = var.plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"

  tags = var.tags
}

resource "azurerm_linux_web_app" "frontend" {
  name                = var.frontend_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  tags = var.tags

  site_config {
    always_on = true
  }

  app_settings = {
    "ENVIRONMENT" = "dev"
  }

}

resource "azurerm_linux_web_app" "backend" {
  name                = var.backend_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  tags = var.tags

  site_config {
    always_on = true
  }

  app_settings = {
    "ENVIRONMENT"          = "dev"
    "DB_CONNECTION_STRING" = var.sql_connection_string
  }

}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_linux_web_app.backend.id
  subnet_id      = var.subnet_id

}

module "diagnostics_frontend" {
  source = "../diagnostics"

  resource_name              = azurerm_linux_web_app.frontend.name
  resource_id                = azurerm_linux_web_app.frontend.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories = [
    "AppServiceHTTPLogs",
    "AppServiceConsoleLogs",
    "AppServiceAuditLogs"
  ]

  metric_categories = [
    "AllMetrics"
  ]

}

module "diagnostics_backend" {
  source = "../diagnostics"

  resource_name              = azurerm_linux_web_app.backend.name
  resource_id                = azurerm_linux_web_app.backend.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories = [
    "AppServiceHTTPLogs",
    "AppServiceConsoleLogs",
    "AppServiceAuditLogs"
  ]

  metric_categories = [
    "AllMetrics"
  ]

}