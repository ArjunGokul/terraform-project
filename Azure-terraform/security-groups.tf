resource "azurerm_network_interface_security_group_association" "kk-nic-nsg" {
  network_interface_id      = azurerm_network_interface.kk-nic.id
  network_security_group_id = azurerm_network_security_group.my-ns.id
}

resource "azurerm_network_security_group" "my-ns" {
  name                = "my-ns"
  location            = data.azurerm_resource_group.my-rg.location
  resource_group_name = data.azurerm_resource_group.my-rg.name


  dynamic "security_rule" {
    for_each = var.inbound_ports

    content {
      name                       = "Allow-${security_rule.value}"
      priority                   = 1000 + index(var.inbound_ports, security_rule.value)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  tags = merge(local.common_tags, {
    Name = "My NSG"
  })
}