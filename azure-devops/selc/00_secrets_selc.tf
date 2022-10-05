#
# PROD SELC KEYVAULT
#

module "selc_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.dev_selc_key_vault_resource_group
  key_vault_name = local.dev_selc_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url",
    "pagopa-selc-d-azure-client-secret",
    "pagopa-selc-d-azure-client-id",
    "selc-d-apim-external-api-key",
  ]
}

# module "selc_uat_secrets" {
#   source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

#   providers = {
#     azurerm = azurerm.uat
#   }

#   resource_group = local.uat_selc_key_vault_resource_group
#   key_vault_name = local.uat_selc_key_vault_name

#   secrets = [
#     "pagopa-u-weu-uat-aks-azure-devops-sa-token",
#     "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
#     "pagopa-u-weu-uat-aks-apiserver-url"
#   ]
# }

module "selc_prod_secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_selc_key_vault_resource_group
  key_vault_name = local.prod_selc_key_vault_name

  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-weu-prod-aks-apiserver-url"
  ]
}
