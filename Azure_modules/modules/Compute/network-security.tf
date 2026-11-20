resource "azurerm_network_interface" "my-nic" {
  for_each            = toset(var.vm_name)
  name                = "${each.value}-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_ids[each.value]
  }

  tags = merge(local.common_tags, {
    Name = "${each.value}-nic"
  })
}

resource "azurerm_network_security_group" "my-nsg" {
  name                = "my-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.inbound_port
    content {
      name                       = "InboundRule-${security_rule.value}"
      priority                   = 1000 + security_rule.value
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
    Name = "my-nsg"
  })
}

resource "azurerm_network_interface_security_group_association" "my-nic-nsg-association" {
  for_each                  = toset(var.vm_name)
  network_interface_id      = azurerm_network_interface.my-nic[each.key].id
  network_security_group_id = azurerm_network_security_group.my-nsg.id
}
