output "vnet_id" {
  description = "The ID of the VPC"
  value       = azurerm_virtual_network.my-vnet.id
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = { for s in azurerm_subnet.my-subnet : s.name => s.id }
}