resource "azurerm_network_security_group" "mysql" {
  name                = "mysql-security-${var.resource_group_location}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "mysql-ingress"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "mysql-egress"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



resource "azurerm_network_security_group" "node" {
  name                = "aks-security-${var.resource_group_location}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "aks-ingress"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*" #if its a private node - accessible for my node where is api gateway located, ingress on port 80 and all egress only from api gateway node and database?
    destination_port_range     = "*"
    source_address_prefix      = "*" #will db send an ingress while responding ?
    destination_address_prefix = "*"
}

  security_rule {
    name                       = "aks-egress"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*" 
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
 }
}

resource "azurerm_network_security_group" "api_gateway" {
  name                = "api-security-${var.resource_group_location}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "api-ingress"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*" 
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}

  security_rule {
    name                       = "api-egress"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*" 
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
 }
}


