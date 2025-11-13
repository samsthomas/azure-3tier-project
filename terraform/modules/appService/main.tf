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