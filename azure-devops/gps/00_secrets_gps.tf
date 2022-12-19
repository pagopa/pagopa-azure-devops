#
# PROD GPS KEYVAULT
#

module "gps_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.dev_gps_key_vault_resource_group
  key_vault_name = local.dev_gps_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url",
    "gpd-payments-d-sa-connection-string",
    "gpd-d-apiconfig-subscription-key"
  ]
}

module "gps_uat_secrets" {
  providers = {
    azurerm = azurerm.uat
  }

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.uat_gps_key_vault_resource_group
  key_vault_name = local.uat_gps_key_vault_name

  secrets = [
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url",
    #    "gpd-payments-u-sa-connection-string",
    #    "gpd-u-apiconfig-subscription-key"
  ]
}

module "gps_prod_secrets" {
  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.prod_gps_key_vault_resource_group
  key_vault_name = local.prod_gps_key_vault_name

  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-weu-prod-aks-apiserver-url"
  ]
}
