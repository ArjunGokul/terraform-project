resource "azurerm_linux_virtual_machine" "my-vm" {
  for_each            = toset(var.vm_name)
  name                = each.value
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.my-nic[each.key].id,
  ]
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
    ]
  }

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.my-public-ip[each.key].ip_address
    user        = var.admin_username
    password    = var.admin_password
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = merge(local.common_tags, {
    Name = each.value
  })
}