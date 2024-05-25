variable "create_cluster" {
  description = "Specifies whether to create the AKS cluster"
  type        = bool
}

variable "location" {
  description = "The location of the AKS cluster"
}

variable "resource_group_name" {
  description = "The name of the resource group where the AKS cluster will be created"
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

variable "node_pool_vnet_subnet_id" {
  type = string
}

variable "node_pool_pod_subnet_id" {
  type = string
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

variable "dns_prefix" {
  type = string
  default = null
}

variable "dns_prefix_private_cluster" {
  type = string
  default = null
}