resource "azurerm_virtual_network" "webclinic" {
  name                = var.vn_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_location
  address_space       = var.address_space
}

resource "azurerm_subnet" "public_subnet" {
  name                 = var.public_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.webclinic.name
  address_prefixes     = var.public_address_prefix
}

resource "azurerm_subnet_network_security_group_association" "public_sg" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = var.public_security_group
}


resource "azurerm_subnet" "aks_subnet" {
  count = var.create_cluster ? 1 : 0

  name                 = var.private_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.webclinic.name
  address_prefixes     = var.private_address_prefix

  delegation {
    name = "ask-delegation"

    service_delegation {
      name = "Microsoft.ContainerInstance/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private_sg" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = var.private_security_group
}

resource "azurerm_public_ip" "nat-public-ip" {
  name                = "aks-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
}

resource "azurerm_nat_gateway" "nat" {
  count = var.create_cluster ? 1 : 0

  name                = "nat-gateway"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_association" {
  count = var.create_cluster ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat-public-ip.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_association" {
  count = var.create_cluster ? 1 : 0

  nat_gateway_id = azurerm_nat_gateway.nat.id
  subnet_id      = azurerm_subnet.aks_subnet.id
}  
