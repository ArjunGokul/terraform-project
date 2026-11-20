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