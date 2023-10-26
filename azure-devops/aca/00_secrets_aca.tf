module "aca_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.dev_aca_key_vault_resource_group
  key_vault_name = local.dev_aca_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url",
    "aca-api-key",
    "aca-load-test-api-key"
  ]
}

module "aca_uat_secrets" {

  providers = {
    azurerm = azurerm.uat
  }

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.uat_aca_key_vault_resource_group
  key_vault_name = local.uat_aca_key_vault_name

  secrets = [
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url",
    "aca-api-key",
    "aca-load-test-api-key"
  ]
}

module "aca_prod_secrets" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.prod_aca_key_vault_resource_group
  key_vault_name = local.prod_aca_key_vault_name

  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-weu-prod-aks-apiserver-url",
    "aca-api-key"
  ]
}

