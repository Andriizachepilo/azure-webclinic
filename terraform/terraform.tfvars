#resource group
resource_group_name     = "webclinic"
resource_group_location = "ukwest"

#networking
vn_name       = "aks-netwroking"
address_space = ["10.0.0.0/20"]

mysql_address_prefix = ["10.0.1.0/24"]

aks_address_prefix = ["10.0.9.0/24"]

agent_address_prefix = ["10.0.5.0/24"]
api_address_prefix   = ["10.0.8.0/24"]


#database
db_engine_version    = "8.0.21"
db_server_sku        = "B_Standard_B1s"
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

#acr
admin_enabled                     = false
acr_sku                           = "Basic"
acr_public_network_access_enabled = true

#cluster
create_cluster = true

name                             = "aks"
kubernetes_version               = "1.29.2"
private_cluster_enabled          = false
sku_tier                         = "Free"
azure_policy_enabled             = false
http_application_routing_enabled = false
dns_prefix                       = "myclstr123"
dns_prefix_private_cluster       = "myclstr123"

node_pool_vm_size                = "Standard_B2s"
node_pool_enable_auto_scaling    = true
node_pool_enable_host_encryption = false
node_pool_enable_node_public_ip  = true
node_pool_max_pods               = 110
node_pool_max_count              = 1
node_pool_min_count              = 1
node_pool_node_count             = 1

network_plugin = "azure"
network_policy = ""
service_cidr   = "10.0.2.0/24"
dns_service_ip = "10.0.2.10"
api_gateway_public_ip = true
