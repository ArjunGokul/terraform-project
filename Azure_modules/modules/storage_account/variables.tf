variable "storage_account_name" {}
variable "resource_group_name" {}
variable "resource_group_location" {}
variable "storage_account_tier" {
  default = "Standard"
}
variable "storage_account_replication_type" {
  default = "LRS"
}