variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_name" { type = string }
variable "address_space" { type = list(string) }

variable "subnets" {
  description = "Map of subnets to create within the Vnet"
  type = map(object({
    address_prefix = string
  }))
}

variable "create_nsgs" {
  description = "Whether to create NSGs for each subnet"
  type        = bool
  default     = true
}

variable "tags" {
  type = map(string)
}