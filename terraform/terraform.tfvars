#resource group
resource_group_name     = "web-clinic"
resource_group_location = "UK west"

#networking
vn_name       = "aks-netwroking"
address_space = ["10.0.0.0/20"]

public_subnet_name    = "public"
public_address_prefix = "10.0.1.0/24"

private_subnet_name    = "private"
private_address_prefix = "10.0.9.0/24"

#cluster
create_cluster = false

name                             = "aks"
kubernetes_version               = "1.29.2"
private_cluster_enabled          = true
sku_tier                         = "Free"
image_cleaner_enabled            = false
azure_policy_enabled             = false
http_application_routing_enabled = false

node_pool_name                   = "webclinic"
node_pool_vm_size                = "Standard_M416ms_v2"
node_pool_availability_zones     = ["zone1", "zone2", "zone3"]
node_pool_enable_auto_scaling    = true
node_pool_enable_host_encryption = false
node_pool_enable_node_public_ip  = true
node_pool_gpu_instance           = "MIG1g"
node_pool_max_pods               = 1
node_pool_max_count              = 1
node_pool_min_count              = 0
node_pool_node_count             = 1

network_plugin = "Azure"
