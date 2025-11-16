variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "plan_name" { type = string }
variable "frontend_app_name" { type = string }
variable "backend_app_name" { type = string }
variable "sql_connection_string" { type = string }
variable "subnet_id" { type = string }
variable "log_analytics_workspace_id" {}
variable "tags" {
  type = map(string)
}

variable "log_categories" {
  type = list(string)
}
variable "metric_categories" {
  type = list(string)
}