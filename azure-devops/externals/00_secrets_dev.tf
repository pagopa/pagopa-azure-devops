module "pagopa-node-forwarder_dev_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"
  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_key_vault_resource_group
  key_vault_name = local.dev_key_vault_name

  secrets = [
    "node-forwarder-api-subscription-key",
  ]
}

module "pagopa-debt-position_dev_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_key_vault_resource_group
  key_vault_name = local.dev_key_vault_name

  secrets = [
    "gpd-api-subscription-key",
  ]
}
