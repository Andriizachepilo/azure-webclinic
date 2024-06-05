resource "azurerm_kubernetes_cluster" "aks_cluster" {
  count = var.create_cluster ? 1 : 0

  name                             = "aks-${var.resource_group_name}"
  location                         = var.location
  resource_group_name              = var.resource_group_name
  kubernetes_version               = var.kubernetes_version
  private_cluster_enabled          = var.private_cluster_enabled
  sku_tier                         = var.sku_tier
  dns_prefix                       = var.private_cluster_enabled ? null : var.dns_prefix
  dns_prefix_private_cluster       = var.private_cluster_enabled ? var.dns_prefix_private_cluster : null
  azure_policy_enabled             = var.azure_policy_enabled
  http_application_routing_enabled = var.http_application_routing_enabled

  dynamic "default_node_pool" {
    for_each = var.node_pool_enable_auto_scaling ? [1] : []

    content {
      name                   = "intrnl${var.location}"
      vm_size                = var.node_pool_vm_size
      vnet_subnet_id         = var.node_pool_vnet_subnet_id
      pod_subnet_id          = var.node_pool_pod_subnet_id
      enable_auto_scaling    = var.node_pool_enable_auto_scaling
      enable_host_encryption = var.node_pool_enable_host_encryption
      enable_node_public_ip  = var.node_pool_enable_node_public_ip
      max_pods               = var.node_pool_max_pods
      max_count              = var.node_pool_max_count
      min_count              = var.node_pool_min_count
      node_count             = var.node_pool_node_count
    }
  }

  network_profile {
    network_plugin = var.network_plugin
    network_policy = var.network_plugin == "azure" ? var.network_plugin : var.network_policy
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "api_gateway" {
  count = var.create_cluster ? 1 : 0

  name                  = "public${var.location}"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster[0].id
  vm_size               = var.node_pool_vm_size
  pod_subnet_id         = var.api_gateway_subnet
  vnet_subnet_id        = var.node_pool_vnet_subnet_id
  node_count            = var.node_pool_node_count
  enable_node_public_ip = var.api_gateway_public_ip
  enable_auto_scaling   = var.node_pool_enable_auto_scaling
  max_pods              = var.node_pool_max_pods
  max_count             = var.node_pool_max_count
  min_count             = var.node_pool_min_count

}

resource "azurerm_role_assignment" "acr_aks" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster[0].identity[0].principal_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}