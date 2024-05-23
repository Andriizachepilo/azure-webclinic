variable "resource_group_location" {
  description = "The location/region where the MySQL server will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group that contains the MySQL server."
  type        = string
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


variable "db_zone" {
  description = "The availability zone where the MySQL server will be created."
  type        = string
}

variable "db_delegated_subnet_id" {
  description = "The ID of the subnet that will be delegated to the MySQL server."
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

variable "key_vault_sku_name" {
  type = string
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

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the key vault."
  type        = bool
  default     = true
}

