output "mysql" {
  value = azurerm_network_security_group.mysql.id
}

output "node" {
  value = azurerm_network_security_group.node.id
}

output "api_gateway" {
  value = azurerm_network_security_group.api_gateway.id
}