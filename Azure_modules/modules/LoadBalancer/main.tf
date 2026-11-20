# Public IP for the load balancer frontend (Standard LB requires a Standard SKU IP)
resource "azurerm_public_ip" "lb-public-ip" {
  name                = "${var.lb_name}-public-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(local.common_tags, {
    Name = "${var.lb_name}-public-ip"
  })
}

resource "azurerm_lb" "my-lb" {
  name                = var.lb_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.lb_name}-frontend"
    public_ip_address_id = azurerm_public_ip.lb-public-ip.id
  }

  tags = merge(local.common_tags, {
    Name = var.lb_name
  })
}

resource "azurerm_lb_backend_address_pool" "my-backend-pool" {
  name            = "${var.lb_name}-backend-pool"
  loadbalancer_id = azurerm_lb.my-lb.id
}

# Health probe: a VM only receives traffic while nginx answers HTTP 200 on "/"
resource "azurerm_lb_probe" "my-probe" {
  name                = "${var.lb_name}-http-probe"
  loadbalancer_id     = azurerm_lb.my-lb.id
  protocol            = "Http"
  port                = var.backend_port
  request_path        = var.probe_path
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "my-lb-rule" {
  name                           = "${var.lb_name}-http-rule"
  loadbalancer_id                = azurerm_lb.my-lb.id
  protocol                       = "Tcp"
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = azurerm_lb.my-lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.my-backend-pool.id]
  probe_id                       = azurerm_lb_probe.my-probe.id

  # VMs keep their own public IPs for outbound traffic, so no SNAT from the LB
  disable_outbound_snat = true
}

# Attach each VM's NIC to the backend pool
resource "azurerm_network_interface_backend_address_pool_association" "my-pool-association" {
  for_each                = var.network_interface_ids
  network_interface_id    = each.value
  ip_configuration_name   = var.ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.my-backend-pool.id
}

# Outbound internet for the VMs (they no longer have their own public IPs).
# Works together with disable_outbound_snat = true on the LB rule above.
resource "azurerm_lb_outbound_rule" "my-outbound-rule" {
  name                    = "${var.lb_name}-outbound-rule"
  loadbalancer_id         = azurerm_lb.my-lb.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.my-backend-pool.id

  frontend_ip_configuration {
    name = azurerm_lb.my-lb.frontend_ip_configuration[0].name
  }
}

# SSH to each VM through the LB: <lb_public_ip>:50001 -> vm-1:22, :50002 -> vm-2:22, ...
locals {
  nic_names = sort(keys(var.network_interface_ids))
  ssh_ports = { for i, name in local.nic_names : name => var.ssh_frontend_port_start + i }
}

resource "azurerm_lb_nat_rule" "ssh" {
  for_each                       = local.ssh_ports
  name                           = "${each.key}-ssh"
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.my-lb.id
  protocol                       = "Tcp"
  frontend_port                  = each.value
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.my-lb.frontend_ip_configuration[0].name
}

resource "azurerm_network_interface_nat_rule_association" "ssh" {
  for_each              = var.network_interface_ids
  network_interface_id  = each.value
  ip_configuration_name = var.ip_configuration_name
  nat_rule_id           = azurerm_lb_nat_rule.ssh[each.key].id
}
