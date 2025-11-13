variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "sql_server_name" { type = string }
variable "database_name" { type = string }
variable "admin_username" { type = string }
variable "admin_password" { type = string }
variable "app_subnet_prefix" { type = string }
variable "tags" {
  type = map(string)
}