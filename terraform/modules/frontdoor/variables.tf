variable "name" { type = string }
variable "resource_group_name" { type = string }

variable "app_service_default_hostname" {
  type        = string
  description = "The defaultHostname of the App Service"
}

variable "backend_default_hostname" {
  type        = string
  description = "The defaultHostname of the App Service"
}

variable "tags" {
  type    = map(string)
  default = {}
}