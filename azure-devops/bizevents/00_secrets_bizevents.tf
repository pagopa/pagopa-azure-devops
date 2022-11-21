#
# DEV BIZ EVENTS KEYVAULT
#

module "bizevents_dev_secrets" {

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_bizevents_key_vault_resource_group
  key_vault_name = local.dev_bizevents_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url",
    "cosmos-d-biz-key",
    "ehub-tx-d-biz-key"
  ]
}

#
# UAT BIZ EVENTS KEYVAULT
#

module "bizevents_uat_secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_bizevents_key_vault_resource_group
  key_vault_name = local.uat_bizevents_key_vault_name

  secrets = [
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url",
    "cosmos-u-biz-key",
    "ehub-tx-u-biz-key"
  ]
}
#
##
## PROD BIZ EVENTS KEYVAULT
##
#
#module "bizevents_prod_secrets" {
#  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"
#
#  providers = {
#    azurerm = azurerm.prod
#  }
#
#  resource_group = local.prod_bizevents_key_vault_resource_group
#  key_vault_name = local.prod_bizevents_key_vault_name
#
#  secrets = [
#    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
#    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
#    "pagopa-p-weu-prod-aks-apiserver-url"
#  ]
#}
