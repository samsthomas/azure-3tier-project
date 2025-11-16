resource_group_name = "rg-3tier-dev"
location            = "uksouth"

vnet_name     = "vnet-3tier-dev"
address_space = ["10.0.0.0/16"]

subnets = {
  "subnet-web-dev" = { address_prefix = "10.0.1.0/24" }
  "subnet-app-dev" = { address_prefix = "10.0.2.0/24" }
  "subnet-db-dev"  = { address_prefix = "10.0.3.0/24" }
}

sql_server_name = "sql-3tier-dev"
admin_username  = "sqladminuser"
database_name   = "sqldb3tierdev"

plan_name         = "plan-3tier-dev"
frontend_app_name = "web-3tier-dev"
backend_app_name  = "api-3tier-dev"

key_vault_name = "kv-3tier-dev"

workspace_name = "law-3tie-dev"

tags = {
  project     = "3tier-app"
  environment = "dev"

}

frontend_app_insights_name = "appi-frontend-3tier-dev"
backend_app_insights_name  = "appi-backend-3tier-dev"


kv_log_categories = [
  "AuditEvent",
]
kv_metric_categories = [
  "AllMetrics",
]

storage_log_categories = []

storage_metric_categories = [
  "AllMetrics"
]


sql_log_categories = [
  "Errors",
  "Timeouts",
  "Blocks",
  "Deadlocks",
  "SQLInsights",
  "QueryStoreRuntimeStatistics",
  "QueryStoreWaitStatistics"
]

sql_metric_categories = [
  "AllMetrics"
]

appinsights_log_categories = [
  "Requests",
  "Exceptions",
  "Traces",
  "Dependencies",
  "Events"
]

appinsights_metric_categories = [
  "AllMetrics"
]


appservice_log_categories = [
  "AppServiceHTTPLogs",
  "AppServiceConsoleLogs",
  "AppServiceAppLogs"
]

appservice_metric_categories = [
  "AllMetrics"
]

