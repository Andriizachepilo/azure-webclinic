output "node_subnet" {
  value = azurerm_subnet.node_subnet.id
}

output "mysql_subnet" {
  value = azurerm_subnet.mysql_subnet.id
}

output "agent_subnet" {
  value = azurerm_subnet.agent_pool_subnet.id
}

output "api_gateway_subnet" {
  value = azurerm_subnet.api_gateway_subnet.id
}