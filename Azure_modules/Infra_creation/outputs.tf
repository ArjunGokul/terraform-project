output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_location" {
  value = module.resource_group.location
}
output "resource_group_id" {
  value = module.resource_group.id
}

output "storage_account_endpoint" {
  value = module.storage_account.endpoint
}

output "vnet_id" {
  value = module.vpc.vnet_id
}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "public_ip" {
  value = module.compute.public_ip
}

output "network_interface_id" {
  value = module.compute.network_interface_id
}