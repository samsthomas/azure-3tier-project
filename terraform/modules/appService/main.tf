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

  tags = var.tags

  site_config {
    minimum_tls_version = "1.2"
    http2_enabled       = true
    ftps_state          = "Disabled"
    always_on           = true

    application_stack {
      docker_image_name   = "${var.acr_login_server}/${var.backend_image_name}:latest"
      docker_registry_url = "https://${var.acr_login_server}"
    }

    cors {
      allowed_origins = []
    }

  }

  app_settings = {
    "ENVIRONMENT"          = "dev"
    "PORT"                 = "3000"
    "DB_CONNECTION_STRING" = var.sql_connection_string
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

  tags = var.tags

  site_config {
    minimum_tls_version = "1.2"
    http2_enabled       = true
    ftps_state          = "Disabled"
    always_on           = true

    application_stack {
      docker_image_name   = "${var.acr_login_server}/${var.frontend_image_name}:latest"
      docker_registry_url = "https://${var.acr_login_server}"
    }


  }

  app_settings = {
    "ENVIRONMENT" = "dev"
    API_URL       = "https://${azurerm_linux_web_app.backend.default_hostname}/api/message"
  }
  depends_on = [
    azurerm_linux_web_app.backend
  ]

}

resource "azurerm_linux_web_app_slot" "backend_cors" {
  name           = "apply-cors"
  app_service_id = azurerm_linux_web_app.backend.id

  site_config {
    cors {
      allowed_origins = [
        "https://${azurerm_linux_web_app.frontend.default_hostname}"
      ]
    }

  }

  depends_on = [
    azurerm_linux_web_app.frontend
  ]

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