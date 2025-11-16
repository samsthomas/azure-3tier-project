resource "azurerm_monitor_diagnostic_setting" "diags" {
  name = "${var.resource_name}-diag"
  target_resource_id = var.resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = var.log_categories
    content {
      category = enabled_log.value
        }
    }

  dynamic "enabled_metric" {
    for_each = var.metric_categories
    content {
      category = metric.value
    }
  }
}