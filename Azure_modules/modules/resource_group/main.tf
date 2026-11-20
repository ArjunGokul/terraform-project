resource "azurerm_resource_group" "my-rg" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    name    = var.resource_group_name
    Project = "Terraform-Azure"
    Owner   = "Arjun"
  }
}