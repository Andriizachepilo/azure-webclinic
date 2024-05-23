resource "azurerm_kubernetes_cluster" "aks_cluster" {
  count = var.create_cluster ? 1 : 0

  name                             = "ask-${var.resource_group_name}"
  location                         = var.location
  resource_group_name              = var.resource_group_name
  kubernetes_version               = var.kubernetes_version
  private_cluster_enabled          = var.private_cluster_enabled
  sku_tier                         = var.sku_tier
  dns_prefix                       = var.private_cluster_enabled ? "" : var.dns_prefix
  dns_prefix_private_cluster       = var.private_cluster_enabled ? var.dns_prefix_private_cluster : ""
  image_cleaner_enabled            = var.image_cleaner_enabled
  azure_policy_enabled             = var.azure_policy_enabled
  http_application_routing_enabled = var.http_application_routing_enabled

  default_node_pool {
    name                   = "node-pool-${var.resource_group_name}"
    vm_size                = var.node_pool_vm_size
    vnet_subnet_id         = var.node_pool_vnet_subnet_id
    pod_subnet_id          = var.node_pool_pod_subnet_id
    zones                  = var.node_pool_availability_zones
    enable_auto_scaling    = var.node_pool_enable_auto_scaling
    enable_host_encryption = var.node_pool_enable_host_encryption
    enable_node_public_ip  = var.node_pool_enable_node_public_ip
    gpu_instance           = var.node_pool_gpu_instance
    max_pods               = var.node_pool_max_pods
    max_count              = var.node_pool_max_count
    min_count              = var.node_pool_min_count
    node_count             = var.node_pool_node_count
  }

  network_profile {
    network_plugin = var.network_plugin
    network_policy = var.network_plugin == "Azure" ? var.network_plugin : var.network_policy
  }

  identity {
    type = "SystemAssigned"
  }
}
