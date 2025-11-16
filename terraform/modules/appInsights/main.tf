resource "azurerm_application_insights" "ai" {
  for_each = var.app_insights

  name = each.value.name
  location = var.location
  resource_group_name = var.resource_group_name
  workspace_id = var.workspace_id

  application_type = "web"

  tags = var.tags
  
}

module "diagnostics_appinsights" {
  source = "../../modules/diagnostics"

  resource_name              = azurerm_application_insights.ai["frontend"].name
  resource_id                = azurerm_application_insights.ai["frontend"].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log_categories = [
    "AllLogs",
  ]

  metric_categories = [
    "AllMetrics"
  ]
}
