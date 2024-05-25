output "aks_subnet" {
  value = azurerm_subnet.aks_subnet.id
}

output "mysql_subnet" {
  value = azurerm_subnet.db_subnet.id
}

output "agent_subnet" {
  value = azurerm_subnet.agent_pool_subnet.id
}