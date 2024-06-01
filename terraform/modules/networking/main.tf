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
  address_prefixes     = var.mysql_address_prefix

  delegation {
    name = "mysql-delegation"

    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "mysql_sg" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = var.db_security_group
}

resource "azurerm_subnet_nat_gateway_association" "subnet_mysql_nat_association" {
  nat_gateway_id = azurerm_nat_gateway.nat.id
  subnet_id      = azurerm_subnet.db_subnet.id
}

resource "azurerm_subnet" "pod_subnet" {
  name                 = "pod-subnet-${var.resource_group_location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.webclinic.name
  address_prefixes     = var.pod_address_prefix
}

resource "azurerm_subnet_network_security_group_association" "pod_sg" {
  subnet_id                 = azurerm_subnet.pod_subnet.id
  network_security_group_id = var.pod_security_group
}

resource "azurerm_subnet_nat_gateway_association" "subnet_pod_nat_association" {
  nat_gateway_id = azurerm_nat_gateway.nat.id
  subnet_id      = azurerm_subnet.pod_subnet.id
}


resource "azurerm_subnet" "agent_pool_subnet" {
  name                 = "agent-subnet-${var.resource_group_location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.webclinic.name
  address_prefixes     = var.agent_address_prefix

  delegation {
    name = "aks-delegation"

    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "agent_sg" {
  subnet_id                 = azurerm_subnet.agent_pool_subnet.id
  network_security_group_id = var.pod_security_group
}


resource "azurerm_subnet" "api_gateway_subnet" {
  name                 = "gateway-subnet-${var.resource_group_location}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.webclinic.name
  address_prefixes     = var.api_address_prefix

    delegation {
    name = "aks-delegation"

    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "gateway_sg" {
  subnet_id                 = azurerm_subnet.api_gateway_subnet.id
  network_security_group_id = var.api_gateway_security_group
}
#associate with public ip? or just assigning public ip for vm will be ok?

resource "azurerm_public_ip" "nat-public-ip" {
  name                = "aks-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_nat_gateway" "nat" {
  name                = "nat-gateway"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  depends_on = [azurerm_public_ip.nat-public-ip]
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat-public-ip.id
}
