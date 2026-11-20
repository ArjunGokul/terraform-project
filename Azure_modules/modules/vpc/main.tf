resource "azurerm_virtual_network" "my-vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags = merge(local.common_tags, {
    Name = var.vnet_name
  })
}

resource "azurerm_subnet" "my-subnet" {
  for_each             = var.subnet_name_address
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.my-vnet.name
  address_prefixes     = [each.value]
}