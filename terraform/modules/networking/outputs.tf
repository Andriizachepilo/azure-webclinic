output "aks_subnet" {
  value = azurerm_subnet.aks_subnet[*].id
}

output "mysql_subnet" {
  value = azurerm_subnet.db_subnet.id
}