module "pagopa-node-forwarder_uat_secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_key_vault_resource_group
  key_vault_name = local.uat_key_vault_name

  secrets = [
    "node-forwarder-api-subscription-key",
  ]
}

# module "pagopa-api-config_uat_secrets" {
#   source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

#   providers = {
#     azurerm = azurerm.uat
#   }

#   resource_group = local.uat_key_vault_resource_group
#   key_vault_name = local.uat_key_vault_name

#   secrets = [
#     "api-config-fe-storage-account-key"
#   ]
# }

module "pagopa-debt-position_uat_secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_key_vault_resource_group
  key_vault_name = local.uat_key_vault_name

  secrets = [
    "gpd-api-subscription-key",
  ]
}
