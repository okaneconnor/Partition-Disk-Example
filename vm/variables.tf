variable "resource_group_name" {
  type = string
  default = "vm_rg"
  description = "resource group name"
}

variable "location" {
  type = string
  default = "eastus"
  description = "location"
}

variable "vm_name" {
  type = string
  default = "example-vm"
  description = "name of vm"
}

variable "vnet_name" {
  type = string
  default = "example-vnet"
  description = "name of vnet"
}