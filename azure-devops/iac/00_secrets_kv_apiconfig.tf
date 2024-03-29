#
# apiconfig KEYVAULT
#

module "apiconfig_dev_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.48.0"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_apiconfig_key_vault_resource_group
  key_vault_name = local.dev_apiconfig_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url"
  ]
}

module "apiconfig_uat_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_apiconfig_key_vault_resource_group
  key_vault_name = local.uat_apiconfig_key_vault_name

  secrets = [
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url"
  ]
}

module "apiconfig_prod_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_apiconfig_key_vault_resource_group
  key_vault_name = local.prod_apiconfig_key_vault_name

  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-weu-prod-aks-apiserver-url"
  ]
}
