#
# PROD GPS KEYVAULT
#

module "shared_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.dev_shared_key_vault_resource_group
  key_vault_name = local.dev_shared_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url"
  ]
}

# module "shared_uat_secrets" {
#   source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

#   resource_group = local.uat_shared_key_vault_resource_group
#   key_vault_name = local.uat_shared_key_vault_name

#   secrets = [
#     "pagopa-u-weu-dev-aks-azure-devops-sa-token",
#     "pagopa-u-weu-dev-aks-azure-devops-sa-cacrt",
#     "pagopa-u-weu-dev-aks-apiserver-url"
#   ]
# }

# module "shared_prod_secrets" {
#   source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

#   resource_group = local.prod_shared_key_vault_resource_group
#   key_vault_name = local.prod_shared_key_vault_name

#   secrets = [
#     "pagopa-p-weu-dev-aks-azure-devops-sa-token",
#     "pagopa-p-weu-dev-aks-azure-devops-sa-cacrt",
#     "pagopa-p-weu-dev-aks-apiserver-url"
#   ]
# }
