data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = "db-keyvault4321988w73"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku_name

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment


  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
      "Recover",
      "Restore",
    ]
  }
}


resource "random_string" "login" {
  length  = var.random_login_length
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "azurerm_key_vault_secret" "mysqllogin" {
  name         = var.login_secret_name
  value        = random_string.login.result
  key_vault_id = azurerm_key_vault.main.id
}

data "azurerm_key_vault_secret" "db_login" {
  name         = azurerm_key_vault_secret.mysqllogin.name
  key_vault_id = azurerm_key_vault.main.id
}

resource "random_password" "mysqlpasswd" {
  length      = var.random_password_length
  min_upper   = 0
  min_lower   = 1
  min_numeric = 1
  min_special = 0
}

resource "azurerm_key_vault_secret" "mysqlpass" {
  name         = var.password_secret_name
  value        = random_password.mysqlpasswd.result
  key_vault_id = azurerm_key_vault.main.id
}

data "azurerm_key_vault_secret" "db_password" {
  name         = azurerm_key_vault_secret.mysqlpass.name
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                = "mysql-server3213w123"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  version             = var.db_engine_version 
  sku_name            = var.db_server_sku
 
  administrator_login    = data.azurerm_key_vault_secret.db_login.value
  administrator_password = data.azurerm_key_vault_secret.db_password.value
  delegated_subnet_id    = var.db_delegated_subnet_id

  storage {
    iops    = var.db_iops
    size_gb = var.db_allocated_storage
  }
}

# resource "azurerm_mysql_flexible_server_configuration" "ssl_enforcement" {
#   name                = "ssl-enforcement"
#   resource_group_name = var.resource_group_name
#   server_name         = azurerm_mysql_flexible_server.mysql.name
#   value               = "Disabled"
# }

resource "azurerm_mysql_flexible_database" "MySQL" {
  name                = "database"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = var.charset
  collation           = var.collation
}
