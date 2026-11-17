resource "azurerm_virtual_network" "my-vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.my-rg.location
  resource_group_name = data.azurerm_resource_group.my-rg.name
  tags = merge(local.common_tags, {
    Name = "my-vnet"
  })
}

resource "azurerm_subnet" "public-subnet-1" {
  name                 = "public-subnet-1"
  resource_group_name  = data.azurerm_resource_group.my-rg.name
  virtual_network_name = azurerm_virtual_network.my-vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_subnet" "public-subnet-2" {
  name                 = "public-subnet-2"
  resource_group_name  = data.azurerm_resource_group.my-rg.name
  virtual_network_name = azurerm_virtual_network.my-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "kk-pip" {
  name                = "kk-pip"
  location            = data.azurerm_resource_group.my-rg.location
  resource_group_name = data.azurerm_resource_group.my-rg.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = local.common_tags
}

resource "azurerm_network_interface" "kk-nic" {
  name                = "kk-nic"
  location            = data.azurerm_resource_group.my-rg.location
  resource_group_name = data.azurerm_resource_group.my-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public-subnet-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.kk-pip.id

  }
  tags = merge(local.common_tags, {
    Name = "My NIC"
  })
}