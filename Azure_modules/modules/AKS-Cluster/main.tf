resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
  }
  node_provisioning_profile {
    mode = "Manual"
  }
  identity {
    type = "SystemAssigned"
  }

  tags = merge(local.common_tags, {
    Name = var.aks_cluster_name
  })
}

resource "azurerm_kubernetes_cluster_node_pool" "aks_node_pool" {
    for_each = var.additional_node_pools
    
    name                = each.value.name
    kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
    vm_size             = each.value.vm_size
    node_count          = each.value.node_count
    os_type             = each.value.os_type
    mode                = each.value.mode
    
    tags = merge(local.common_tags, {
        Name = "${var.aks_cluster_name}-${each.value.name}"
    })
}