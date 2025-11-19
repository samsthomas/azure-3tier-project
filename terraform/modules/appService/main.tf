resource "azurerm_service_plan" "plan" {
  name                = var.plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"

  tags = var.tags
}

resource "azurerm_linux_web_app" "backend" {
  name                = var.backend_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = var.subnet_id
  tags                      = var.tags

  site_config {
    minimum_tls_version = "1.2"
    http2_enabled       = true
    ftps_state          = "Disabled"
    always_on           = true

    application_stack {
      docker_image_name   = "${var.backend_image_name}:latest"
      docker_registry_url = "https://${var.acr_login_server}"
    }

    container_registry_use_managed_identity = true

  }

  app_settings = {
    "ENVIRONMENT"          = "dev"
    "DB_CONNECTION_STRING" = var.sql_connection_string
    FRONTEND_HOSTNAME      = "${var.frontend_app_name}.azurewebsites.net"

    WEBSITE_CORS_ALLOWED_ORIGINS     = "https://${var.frontend_app_name}.azurewebsites.net"
    WEBSITE_CORS_SUPPORT_CREDENTIALS = "false"
  }

}

resource "azurerm_linux_web_app" "frontend" {
  name                = var.frontend_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = var.subnet_id
  tags                      = var.tags

  site_config {
    minimum_tls_version = "1.2"
    http2_enabled       = true
    ftps_state          = "Disabled"
    always_on           = true

    application_stack {
      docker_image_name   = "${var.frontend_image_name}:latest"
      docker_registry_url = "https://${var.acr_login_server}"
    }

    container_registry_use_managed_identity = true


  }

  app_settings = {
    "ENVIRONMENT" = "dev"
    API_URL       = "https://${azurerm_linux_web_app.backend.default_hostname}/api/message"
  }
  depends_on = [
    azurerm_linux_web_app.backend
  ]

}

resource "azurerm_role_assignment" "frontend_acr_pull" {
  principal_id         = azurerm_linux_web_app.frontend.identity[0].principal_id
  scope                = var.acr_id
  role_definition_name = "AcrPull"
}

resource "azurerm_role_assignment" "backend_acr_pull" {
  principal_id         = azurerm_linux_web_app.backend.identity[0].principal_id
  scope                = var.acr_id
  role_definition_name = "AcrPull"
}

resource "azurerm_app_service_virtual_network_swift_connection" "backend" {
  app_service_id = azurerm_linux_web_app.backend.id
  subnet_id      = var.subnet_id
}



module "diagnostics_frontend" {
  source = "../diagnostics"

  resource_name              = azurerm_linux_web_app.frontend.name
  resource_id                = azurerm_linux_web_app.frontend.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories    = var.log_categories
  metric_categories = var.metric_categories

}

module "diagnostics_backend" {
  source = "../diagnostics"

  resource_name              = azurerm_linux_web_app.backend.name
  resource_id                = azurerm_linux_web_app.backend.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories    = var.log_categories
  metric_categories = var.metric_categories


}