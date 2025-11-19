variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "sql_server_name" { type = string }
variable "database_name" { type = string }
variable "admin_username" { type = string }
variable "admin_password" { type = string }
variable "app_subnet_prefix" { type = string }
variable "log_analytics_workspace_id" {}
variable "db_subnet_id" { type = string }
variable "vnet_id" { type = string }
variable "tags" {
  type = map(string)
}

variable "log_categories" {
  type = list(string)
}
variable "metric_categories" {
  type = list(string)
}

