output "private_ip" {
  value = { for nic in azurerm_network_interface.my-nic : nic.name => nic.private_ip_address }
}

output "network_interface_id" {
  value = { for nic in azurerm_network_interface.my-nic : nic.name => nic.id }
}

output "linux_vm_id" {
  value = { for vm in azurerm_linux_virtual_machine.my-vm : vm.name => vm.id }
}