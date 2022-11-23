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
