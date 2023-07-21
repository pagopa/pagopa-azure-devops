#
# DEV RECEIPTS KEYVAULT
#

module "receipts_dev_secrets" {

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_receipts_key_vault_resource_group
  key_vault_name = local.dev_receipts_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url",
    "cosmos-bizevent-pkey",
    "cosmos-receipt-pkey"
  ]
}

#
# UAT RECEIPTS KEYVAULT
#

module "receipts_uat_secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_receipts_key_vault_resource_group
  key_vault_name = local.uat_receipts_key_vault_name

  secrets = [
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url",
    "cosmos-bizevent-pkey",
    "cosmos-receipt-pkey"
  ]
}


# #
# # PROD RECEIPTS KEYVAULT
# #

# module "receipts_prod_secrets" {
#   source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

#   providers = {
#     azurerm = azurerm.prod
#   }

#   resource_group = local.prod_receipts_key_vault_resource_group
#   key_vault_name = local.prod_receipts_key_vault_name

#   secrets = [
#     "pagopa-p-weu-prod-aks-azure-devops-sa-token",
#     "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
#     "pagopa-p-weu-prod-aks-apiserver-url",
#   ]
# }
