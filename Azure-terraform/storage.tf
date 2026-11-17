#resource "azurerm_storage_account" "kk-storage" {
#  name                     = "kkstorage"
#  resource_group_name      = data.azurerm_resource_group.my-rg.name
#  location                 = data.azurerm_resource_group.my-rg.location
#  account_tier             = "Standard"
#  account_replication_type = "LRS"

#  tags = merge(local.common_tags, {
#    Name = "kk-storage"
#  })
#}