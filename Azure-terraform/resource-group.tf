#resource "azurerm_resource_group" "my-rg" {
#  location = var.location
#  name     = var.resource_group_name
#  tags = merge(local.common_tags, {
#    Name = "My Resource Group"
#  })
#}