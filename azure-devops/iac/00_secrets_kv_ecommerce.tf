#
# ecommerce KEYVAULT
#

module "ecommerce_dev_secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.18.9"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_ecommerce_key_vault_resource_group
  key_vault_name = local.dev_ecommerce_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url"
  ]
}

module "ecommerce_uat_secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.18.9"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_ecommerce_key_vault_resource_group
  key_vault_name = local.uat_ecommerce_key_vault_name

  secrets = [
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url"
  ]
}

module "ecommerce_prod_secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.18.9"

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_ecommerce_key_vault_resource_group
  key_vault_name = local.prod_ecommerce_key_vault_name

  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-weu-prod-aks-apiserver-url"
  ]
}
