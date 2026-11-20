variable "resource_group_name" {}
variable "resource_group_location" {}
variable "storage_account_name" {}
variable "vnet_address_space" {}
variable "vnet_name" {}
variable "disk_size_gb" {}
variable "subnet_name_address" {
  type = map(string)
}
variable "vm_name" {
  type = set(string)
}
variable "vm_size" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "os_disk_size" {
  type = number
}