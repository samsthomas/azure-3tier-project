variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "key_vault_name" { type = string }
variable "tenant_id" { type = string }
variable "current_user_object_id" { type = string }
variable "sql_admin_password" { type = string }
variable "github_oidc_object_id" { type = string }
variable "log_analytics_workspace_id" {}
variable "tags" {
  type = map(string)
}