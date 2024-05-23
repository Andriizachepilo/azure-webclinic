resource "azurerm_virtual_network" "webclinic" {
  name                = "Vnet-${var.resource_group_location}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet-${var.resource_group_location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.webclinic.name
  address_prefixes     = var.public_address_prefix
    delegation {
        name = "mysql-delegation"

        service_delegation {
            name    = "Microsoft.DBforMySQL/flexibleServers"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action",]
        }
    }
}

resource "azurerm_subnet_network_security_group_association" "db_sg" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = var.db_security_group
}


resource "azurerm_subnet" "aks_subnet" {
  count = var.create_cluster ? 1 : 0

  name                 = "ask-subnet-${var.resource_group_location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.webclinic.name
  address_prefixes     = var.private_address_prefix

  delegation {
    name = "ask-delegation"

    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private_sg" {
  subnet_id                 = azurerm_subnet.aks_subnet[*].id
  network_security_group_id = var.aks_security_group
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

  nat_gateway_id       = azurerm_nat_gateway.nat[*].id
  public_ip_address_id = azurerm_public_ip.nat-public-ip.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet__aks_nat_association" {
  count = var.create_cluster ? 1 : 0

  nat_gateway_id = azurerm_nat_gateway.nat[*].id
  subnet_id      = azurerm_subnet.aks_subnet[*].id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_mysql_nat_association" {
  nat_gateway_id = azurerm_nat_gateway.nat[*].id
  subnet_id      = azurerm_subnet.db_subnet.id
}