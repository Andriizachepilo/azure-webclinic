resource "azurerm_network_security_group" "mysql" {
  name                = "mysql-security-${var.resource_group_location}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

#ingress traffic from the node where customers, vets and visits services are located.
  security_rule {
    name                       = "mysql-ingress"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = ["10.0.9.0/24"]
    destination_address_prefix = "*"
  }

#ingress only from my IP for the workbench
  security_rule {
    name                       = "mysql-ingress-workbench"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*" #ephemeral ports
    destination_port_range     = "3306"
    source_address_prefix      = join(",", var.my_ip_address)
    destination_address_prefix = "*"
  }

#all egress 
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

# allow traffic from the API-GATEWAY, since all the services within this node do not need to be exposed
  security_rule {
    name                       = "aks-ingress"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*" 
    destination_port_range     = "*"
    source_address_prefix      = ["10.0.8.0/24"]
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

#allow all traffic
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


