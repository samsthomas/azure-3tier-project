variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "workspace_id" { type = string }
variable "log_analytics_workspace_id" {}

variable "app_insights" {
  type = map(object({
    name = string
  }))
}

variable "tags" {
  type = map(string)
}

variable "log_categories" {
  type = list(string)
}

variable "metric_categories" {
  type = list(string)
}