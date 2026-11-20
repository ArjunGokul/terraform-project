output "lb_id" {
  value = azurerm_lb.my-lb.id
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb-public-ip.ip_address
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.my-backend-pool.id
}

output "ssh_endpoints" {
  description = "SSH command per VM via LB inbound NAT rules."
  value       = { for name, port in local.ssh_ports : name => "ssh -p ${port} <admin_username>@${azurerm_public_ip.lb-public-ip.ip_address}" }
}
