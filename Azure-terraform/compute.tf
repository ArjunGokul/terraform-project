resource "azurerm_linux_virtual_machine" "kk-vm" {
  name                = "kk-vm"
  location            = data.azurerm_resource_group.my-rg.location
  resource_group_name = data.azurerm_resource_group.my-rg.name
  size                = "Standard_D4alds_v6"
  admin_username      = "adminuser"
  admin_password      = "Kodekloudmy-rg1!"
  custom_data         = filebase64("install-nginx.sh")

  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.kk-nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  tags = merge(local.common_tags, {
    Name = "nginx-vm"
  })
}

