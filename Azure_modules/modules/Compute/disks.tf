resource "azurerm_managed_disk" "my-disk" {
  for_each            = toset(var.vm_name)
  name                = "${each.value}-disk"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option       = "Empty"
  disk_size_gb        = var.disk_size_gb

  tags = merge(local.common_tags, {
    Name = "${each.value}-disk"
  })
}