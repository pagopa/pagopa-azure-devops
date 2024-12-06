module "wallet_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  resource_group = local.dev_wallet_key_vault_resource_group
  key_vault_name = local.dev_wallet_key_vault_name

  secrets = [
    "pagopa-d-itn-dev-aks-azure-devops-sa-token",
    "pagopa-d-itn-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-itn-dev-aks-apiserver-url",
    "wallet-token-test-key",
    "wallet-migration-api-key-test-dev",
    "wallet-migration-cstar-api-key-test-dev",
    "migration-wallet-token-test-dev"
  ]
}

module "wallet_uat_secrets" {

  providers = {
    azurerm = azurerm.uat
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  resource_group = local.uat_wallet_key_vault_resource_group
  key_vault_name = local.uat_wallet_key_vault_name

  secrets = [
    "pagopa-u-itn-uat-aks-azure-devops-sa-token",
    "pagopa-u-itn-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-itn-uat-aks-apiserver-url",
    "wallet-token-test-key",
    "wallet-storage-connection-string",
    "receiver-evt-rx-event-hub-connection-string-test"
  ]
}

module "wallet_prod_secrets" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  resource_group = local.prod_wallet_key_vault_resource_group
  key_vault_name = local.prod_wallet_key_vault_name

  secrets = [
    "pagopa-p-itn-prod-aks-azure-devops-sa-token",
    "pagopa-p-itn-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-itn-prod-aks-apiserver-url"
  ]
}
