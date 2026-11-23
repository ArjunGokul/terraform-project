variable aks_cluster_name {}
variable resource_group_name {}
variable resource_group_location {}
variable dns_prefix {}
variable node_count {
    type = number
    description = "Number of nodes in the default node pool"
}
variable vm_size {
    type = string
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
}
