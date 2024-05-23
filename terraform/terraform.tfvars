#resource group
resource_group_name     = "web-clinic"
resource_group_location = "UK west"

#networking
vn_name       = "aks-netwroking"
address_space = ["10.0.0.0/20"]

public_address_prefix = ["10.0.1.0/24"]

private_address_prefix = ["10.0.9.0/24"]

#database
db_engine_version    = "8.0.21"
db_server_sku        = "B_Standard_B1s"
db_zone              = "zone 1"
db_iops              = 444
db_allocated_storage = 444

charset   = "utf8"
collation = "utf8_unicode_ci"

key_vault_sku_name              = "standard"
enabled_for_deployment          = true
enabled_for_disk_encryption     = false
enabled_for_template_deployment = false

random_login_length = 9
login_secret_name   = "secretlog"

random_password_length = 9
password_secret_name   = "secretpass"


#cluster
create_cluster = false

name                             = "aks"
kubernetes_version               = "1.29.2"
private_cluster_enabled          = true
sku_tier                         = "Free"
image_cleaner_enabled            = false
azure_policy_enabled             = false
http_application_routing_enabled = false
dns_prefix                       = "myclstr123"
dns_prefix_private_cluster       = "myclstr123"

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
network_policy = ""
