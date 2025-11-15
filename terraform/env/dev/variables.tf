variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "address_space" { type = list(string) }

variable "subnets" {
  type = map(object({
    address_prefix = string
  }))
}

variable "sql_server_name" { type = string }
variable "admin_username" { type = string }
variable "admin_password" { type = string }
variable "database_name" { type = string }

variable "plan_name" { type = string }
variable "frontend_app_name" { type = string }
variable "backend_app_name" { type = string }

variable "tags" {
  type = map(string)
}

variable "key_vault_name" { type = string }

variable "workspace_name" { type = string }

variable "frontend_app_insights_name" { type = string }
variable "backend_app_insights_name" { type = string }

variable "github_oidc_object_id" { type = string }



