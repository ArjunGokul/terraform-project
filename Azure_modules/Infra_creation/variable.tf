variable "resource_group_name" {}
variable "resource_group_location" {}
variable "aks_cluster_name" {}
variable "dns_prefix" {}
variable "node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
}
variable "vm_size" {
  type        = string
  description = "VM size for the default node pool"
}
variable "additional_node_pools" {
  type = map(object({
    name       = string
    vm_size    = string
    node_count = number
    os_type    = string
    mode       = string
  }))
  description = "Additional node pools keyed by pool name"
}
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
