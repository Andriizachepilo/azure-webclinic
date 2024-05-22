module "resource-group" {
  source = "./modules/resource-group"

  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name
}

module "netwroking" {
  source = "./modules/networking"

  resource_group_name     = module.resource-group.name
  resource_group_location = module.resource-group.location

  vn_name       = var.vn_name
  address_space = var.address_space

  private_subnet_name    = var.private_subnet_name
  private_address_prefix = var.private_address_prefix
  private_security_group = module.security-group.test123-sg

  public_subnet_name    = var.public_subnet_name
  public_address_prefix = var.public_address_prefix
  public_security_group = module.security-group.test123-sg

  create_cluster = var.create_cluster
}

module "security-group" {
  source = "./modules/security"

  resource_group_location = module.resource-group.location
  resource_group_name     = module.resource-group.name
}

module "kubernetes" {
  source = "./modules/aks"

  create_cluster = var.create_cluster

  name                             = var.name
  location                         = module.resource-group.location
  resource_group_name              = module.resource-group.name
  kubernetes_version               = var.kubernetes_version
  private_cluster_enabled          = var.private_cluster_enabled
  sku_tier                         = var.sku_tier
  image_cleaner_enabled            = var.image_cleaner_enabled
  azure_policy_enabled             = var.azure_policy_enabled
  http_application_routing_enabled = var.http_application_routing_enabled

  node_pool_name                   = var.node_pool_name
  node_pool_vm_size                = var.node_pool_vm_size
  node_pool_vnet_subnet_id         = module.netwroking.aks_subnet
  node_pool_pod_subnet_id          = module.netwroking.aks_subnet
  node_pool_availability_zones     = var.node_pool_availability_zones
  node_pool_enable_auto_scaling    = var.node_pool_enable_auto_scaling
  node_pool_enable_host_encryption = var.node_pool_enable_host_encryption
  node_pool_enable_node_public_ip  = var.node_pool_enable_node_public_ip
  node_pool_gpu_instance           = var.node_pool_gpu_instance
  node_pool_max_pods               = var.node_pool_max_pods
  node_pool_max_count              = var.node_pool_max_count
  node_pool_min_count              = var.node_pool_min_count
  node_pool_node_count             = var.node_pool_node_count

  network_plugin = var.network_plugin
  network_policy = var.network_policy

}



