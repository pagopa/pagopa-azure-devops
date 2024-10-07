#
# DEV GPS KEYVAULT
#

module "gps_dev_secrets" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"

  providers = {
    azurerm = azurerm.dev
  }


  resource_group = local.dev_gps_key_vault_resource_group
  key_vault_name = local.dev_gps_key_vault_name

  secrets = [
    "gpd-api-subscription-key",
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url",
    "gpd-d-apiconfig-subscription-key",
    "gpd-d-gps-subscription-key",
    "gpd-d-gpd-subscription-key",
    "gpd-d-donations-subscription-key",
    "gpd-d-iuv-generator-subscription-key",
    "gpd-d-payments-rest-subscription-key",
    "gpd-d-payments-soap-subscription-key",
    "gpd-d-reporting-enrollment-subscription-key",
    "gpd-d-reporting-subscription-key",
    "gpd-d-reporting-batch-connection-string"
  ]
}
module "common_dev_secrets" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_common_key_vault_resource_group_name
  key_vault_name = local.dev_common_key_vault_name

  secrets = [
    "integration-test-subkey"
  ]
}

module "gps_uat_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"

  providers = {
    azurerm = azurerm.uat
  }


  resource_group = local.uat_gps_key_vault_resource_group
  key_vault_name = local.uat_gps_key_vault_name

  secrets = [
    "gpd-api-subscription-key",
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url",
    "gpd-u-apiconfig-subscription-key",
    "gpd-u-gps-subscription-key",
    "gpd-u-gpd-subscription-key",
    "gpd-u-donations-subscription-key",
    "gpd-u-iuv-generator-subscription-key",
    "gpd-u-payments-rest-subscription-key",
    "gpd-u-payments-soap-subscription-key",
    "gpd-u-reporting-enrollment-subscription-key",
    "gpd-u-reporting-subscription-key",
    "gpd-u-reporting-batch-connection-string"
  ]
}

module "gps_prod_secrets" {
  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"

  resource_group = local.prod_gps_key_vault_resource_group
  key_vault_name = local.prod_gps_key_vault_name

  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-weu-prod-aks-apiserver-url"
  ]
}
