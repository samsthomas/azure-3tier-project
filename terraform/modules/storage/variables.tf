variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "storage_account_name" { type = string }
variable "log_analytics_workspace_id" {}
variable "tags" { 
    type = map(string)  
    default = {}
    }