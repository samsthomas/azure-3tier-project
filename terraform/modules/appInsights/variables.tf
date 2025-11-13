variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "workspace_id" { type = string }

variable "app_insights" {
    type = map(object({
        name = string
    }))
}

variable "tags" {
  type = map(string)
}