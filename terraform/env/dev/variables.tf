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

variable "kv_log_categories" {
  type = list(string)
}
variable "kv_metric_categories" {
  type = list(string)
}

variable "storage_log_categories" {
  type = list(string)
}
variable "storage_metric_categories" {
  type = list(string)
}


variable "sql_log_categories" {
  type = list(string)
}
variable "sql_metric_categories" {
  type = list(string)
}


variable "appinsights_log_categories" {
  type = list(string)
}
variable "appinsights_metric_categories" {
  type = list(string)
}

variable "appservice_log_categories" {
  type = list(string)
}
variable "appservice_metric_categories" {
  type = list(string)
}

variable "acr_name" { type = string }
variable "frontend_image_name" { type = string }
variable "backend_image_name" { type = string }


