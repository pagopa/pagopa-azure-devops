data "azurerm_client_config" "current" {}
#
# 🔐 KV
#
data "azurerm_key_vault" "kv_dev" {
  provider = azurerm.dev

  name                = local.dev_key_vault_name
  resource_group_name = local.dev_key_vault_resource_group
}

data "azurerm_key_vault" "kv_uat" {
  provider = azurerm.uat

  name                = local.uat_key_vault_name
  resource_group_name = local.uat_key_vault_resource_group
}

data "azurerm_key_vault" "kv_prod" {
  provider = azurerm.prod

  name                = local.prod_key_vault_name
  resource_group_name = local.prod_key_vault_resource_group
}

# azure devops policy
data "azurerm_subscription" "subscription_dev" {
  provider = azurerm.dev
}

data "azurerm_subscription" "subscription_uat" {
  provider = azurerm.uat
}

data "azurerm_subscription" "subscription_prod" {
  provider = azurerm.prod
}

#
# Service principal
#
data "azuread_service_principal" "iac_principal_dev" {
  display_name = "pagopaspa-pagoPA-iac-${data.azurerm_subscription.subscription_dev.subscription_id}"
}

data "azuread_service_principal" "iac_principal_uat" {
  display_name = "pagopaspa-pagoPA-iac-${data.azurerm_subscription.subscription_uat.subscription_id}"
}

data "azuread_service_principal" "iac_principal_prod" {
  display_name = "pagopaspa-pagoPA-iac-${data.azurerm_subscription.subscription_prod.subscription_id}"
}

#
# KV Policy
#
resource "azurerm_key_vault_access_policy" "azdevops_iac_policy_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.iac_principal_dev.object_id

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]

  storage_permissions = []
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_policy_uat" {
  provider = azurerm.uat

  key_vault_id = data.azurerm_key_vault.kv_uat.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.iac_principal_uat.object_id

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]

  storage_permissions = []
}

resource "azurerm_key_vault_access_policy" "azdevops_iac_policy_prod" {
  provider = azurerm.prod

  key_vault_id = data.azurerm_key_vault.kv_prod.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.iac_principal_prod.object_id

  secret_permissions = ["Get", "List", "Set", ]

  certificate_permissions = ["SetIssuers", "DeleteIssuers", "Purge", "List", "Get"]

  storage_permissions = []
}

