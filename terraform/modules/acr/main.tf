resource "azurerm_container_registry" "acr" {
  name                          = "acr${var.resource_group_location}uniq"
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  sku                           = var.acr_sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.acr_public_network_access_enabled
}
