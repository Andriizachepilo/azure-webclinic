variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "vn_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}


variable "aks_address_prefix" {
  type = list(string)
}

variable "mysql_address_prefix" {
  type = list(string)
}

variable "acr_sku" {
  type = string
}

variable "admin_enabled" {
  type = bool
}

variable "acr_public_network_access_enabled" {
  type = bool
}

variable "create_cluster" {
  description = "Specifies whether to create the AKS cluster"
  type        = bool
}

variable "name" {
  description = "The name of the AKS cluster"
}


variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster"
}

variable "private_cluster_enabled" {
  description = "Specifies whether the AKS cluster is private"
  type        = bool
}

variable "sku_tier" {
  description = "The SKU tier for the AKS cluster"
}



variable "azure_policy_enabled" {
  description = "Specifies whether Azure Policy is enabled for the AKS cluster"
  type        = bool
}

variable "http_application_routing_enabled" {
  description = "Specifies whether HTTP application routing is enabled for the AKS cluster"
  type        = bool
}


variable "node_pool_vm_size" {
  description = "The VM size for the default node pool"
}


variable "node_pool_enable_auto_scaling" {
  description = "Specifies whether auto scaling is enabled for the default node pool"
  type        = bool
}

variable "node_pool_enable_host_encryption" {
  description = "Specifies whether host encryption is enabled for the default node pool"
  type        = bool
}

variable "node_pool_enable_node_public_ip" {
  description = "Specifies whether nodes in the default node pool have public IPs"
  type        = bool
}


variable "node_pool_max_pods" {
  description = "The maximum number of pods per node in the default node pool"
}

variable "node_pool_max_count" {
  description = "The maximum number of nodes in the default node pool"
}

variable "node_pool_min_count" {
  description = "The minimum number of nodes in the default node pool"
}

variable "node_pool_node_count" {
  description = "The initial number of nodes in the default node pool"
}

variable "network_plugin" {
  description = "The network plugin to use for networking"
}

variable "network_policy" {
  description = "The network policy to use for the AKS cluster"
}



variable "db_engine_version" {
  description = "The version of the MySQL server."
  type        = string
  default     = "8.0"
}

variable "db_server_sku" {
  description = "The SKU of the MySQL server."
  type        = string
}


variable "db_iops" {
  description = "The number of IOPS for the MySQL server storage."
  type        = number
}

variable "db_allocated_storage" {
  description = "The size of the storage for the MySQL server in GB."
  type        = number
}


variable "charset" {
  description = "The character set for the MySQL database."
  type        = string
  default     = "utf8"
}

variable "collation" {
  description = "The collation for the MySQL database."
  type        = string
  default     = "utf8_general_ci"
}

variable "random_login_length" {
  type = number
}

variable "random_password_length" {
  type = number
}

variable "login_secret_name" {
  type = string
}

variable "password_secret_name" {
  type = string
}

variable "enabled_for_deployment" {
  description = "Whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets from the key vault and unwrap keys."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Whether Azure Resource Manager is permitted to retrieve secrets from the key vault when deploying resources."
  type        = bool
  default     = false
}

variable "key_vault_sku_name" {
  type = string
}

variable "dns_prefix" {
  type = string
  default = ""
}

variable "dns_prefix_private_cluster" {
  type = string
  default = ""
}

variable "agent_address_prefix" {
  type = list(string)
}