resource "azurerm_load_balancer" "example" {
  name                = "example-loadbalancer"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = "BackendPool"
  }

  probe {
    name                = "HealthProbe"
    protocol            = "Tcp"
    port                = 80
    interval_in_seconds = 5
    number_of_probes    = 2
  }

  load_balancing_rule {
    name                           = "HTTPRule"
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = "PublicIPAddress"
    backend_address_pool_name      = "BackendPool"
    probe_name                     = "HealthProbe"
  }
}