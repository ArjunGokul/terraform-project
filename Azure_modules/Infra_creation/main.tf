module "resource_group" {
  source                  = "../modules/resource_group"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "storage_account" {
  source                  = "../modules/storage_account"
  storage_account_name    = var.storage_account_name
  resource_group_name     = module.resource_group.name
  resource_group_location = module.resource_group.location
}

module "vpc" {
  source                  = "../modules/vpc"
  vnet_name               = var.vnet_name
  vnet_address_space      = var.vnet_address_space
  subnet_name_address     = var.subnet_name_address
  resource_group_name     = module.resource_group.name
  resource_group_location = module.resource_group.location
}

locals {
  vm_subnet_map = {
    "nginx-vm-1" = module.vpc.subnet_ids["subnet1"]
    "nginx-vm-2" = module.vpc.subnet_ids["subnet2"]
  }
}

module "compute" {
  source                  = "../modules/Compute"
  vm_name                 = var.vm_name
  vm_size                 = var.vm_size
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  resource_group_name     = module.resource_group.name
  resource_group_location = module.resource_group.location
  os_disk_size            = var.os_disk_size
  subnet_ids              = local.vm_subnet_map
}

module "load_balancer" {
  source                  = "../modules/LoadBalancer"
  lb_name                 = "nginx-lb"
  resource_group_name     = module.resource_group.name
  resource_group_location = module.resource_group.location
  network_interface_ids   = module.compute.network_interface_id
}

# Install nginx via the Azure Custom Script extension (replaces the old SSH remote-exec,
# which needed a public IP on each VM). Waits for the LB so outbound internet works for apt.
resource "azurerm_virtual_machine_extension" "nginx" {
  for_each             = module.compute.linux_vm_id
  name                 = "install-nginx"
  virtual_machine_id   = each.value
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = "apt-get update -y && apt-get install -y nginx && echo \"Hello from $(hostname)\" > /var/www/html/index.nginx-debian.html"
  })

  depends_on = [module.load_balancer]
}
