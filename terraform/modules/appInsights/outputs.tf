output "instrumentation_keys" {
  value = {
    for k, v in azurerm_application_insights.ai : k => v.instrumentation_key
  }
}

output "connection_string" {
  value = {
    for k, v in azurerm_application_insights.ai : k => v.connection_string
  }
}