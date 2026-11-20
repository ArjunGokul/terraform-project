variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space of the virtual network."
  type        = string
}

variable "subnet_name_address" {
  description = "The name and address space of the subnet."
  type        = map(string)
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}
variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}