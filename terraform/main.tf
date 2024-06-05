module "resource-group" {
  source = "./modules/resource-group"

  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name
}

module "netwroking" {
  source = "./modules/networking"

  resource_group_name     = module.resource-group.name
  resource_group_location = module.resource-group.location

  address_space = var.address_space

  api_address_prefix   = var.api_address_prefix
  pod_address_prefix   = var.aks_address_prefix
  agent_address_prefix = var.agent_address_prefix
  mysql_address_prefix = var.mysql_address_prefix

  db_security_group          = module.security-group.mysql
  pod_security_group         = module.security-group.node
  api_gateway_security_group = module.security-group.api_gateway

  create_cluster = var.create_cluster
}

module "security-group" {
  source = "./modules/security"

  resource_group_location = module.resource-group.location
  resource_group_name     = module.resource-group.name
}

module "acr" {
  source = "./modules/acr"

  resource_group_location = module.resource-group.location
  resource_group_name     = module.resource-group.name

  admin_enabled                     = var.admin_enabled
  acr_sku                           = var.acr_sku
  acr_public_network_access_enabled = var.acr_public_network_access_enabled
}


module "mysql" {
  source = "./modules/mysql"

  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name

  db_engine_version      = var.db_engine_version
  db_server_sku          = var.db_server_sku
  db_delegated_subnet_id = module.netwroking.mysql_subnet
  db_iops                = var.db_iops
  db_allocated_storage   = var.db_allocated_storage

  charset   = var.charset
  collation = var.collation

  key_vault_sku_name              = var.key_vault_sku_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  random_login_length    = var.random_login_length
  login_secret_name      = var.login_secret_name
  random_password_length = var.random_password_length
  password_secret_name   = var.password_secret_name

  depends_on = [module.resource-group]
}



module "kubernetes" {
  source = "./modules/aks"

  create_cluster = var.create_cluster

  location            = module.resource-group.location
  resource_group_name = module.resource-group.name

  kubernetes_version               = var.kubernetes_version
  private_cluster_enabled          = var.private_cluster_enabled
  sku_tier                         = var.sku_tier
  dns_prefix                       = var.dns_prefix
  dns_prefix_private_cluster       = var.dns_prefix_private_cluster
  azure_policy_enabled             = var.azure_policy_enabled
  http_application_routing_enabled = var.http_application_routing_enabled

  dns_service_ip                   = var.dns_service_ip
  service_cidr                     = var.service_cidr
  node_pool_vnet_subnet_id         = module.netwroking.pod_subnet
  node_pool_vm_size                = var.node_pool_vm_size
  node_pool_pod_subnet_id          = module.netwroking.agent_subnet
  node_pool_enable_auto_scaling    = var.node_pool_enable_auto_scaling
  node_pool_enable_host_encryption = var.node_pool_enable_host_encryption
  node_pool_enable_node_public_ip  = var.node_pool_enable_node_public_ip
  node_pool_max_pods               = var.node_pool_max_pods
  node_pool_max_count              = var.node_pool_max_count
  node_pool_min_count              = var.node_pool_min_count
  node_pool_node_count             = var.node_pool_node_count

  api_gateway_public_ip = var.api_gateway_public_ip
  api_gateway_subnet    = module.netwroking.api_gateway_subnet

  network_plugin = var.network_plugin
  network_policy = var.network_policy

  acr_id = module.acr.acr
}



