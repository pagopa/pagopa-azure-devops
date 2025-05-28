module "pagopa-node-forwarder_dev_secrets" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"
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
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_key_vault_resource_group
  key_vault_name = local.dev_key_vault_name

  secrets = [
    "gpd-api-subscription-key",
  ]
}

module "pagopa_core_dev_secrets" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_key_vault_resource_group
  key_vault_name = local.dev_key_vault_name

  secrets = [
    "tls-cert-diff-receiver-emails",
    "tls-cert-diff-sender-email",
    "tls-cert-diff-sender-email-app-pass",
  ]
}
