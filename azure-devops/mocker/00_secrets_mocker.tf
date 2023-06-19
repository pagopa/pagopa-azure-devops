#
# DEV MOCKER KEYVAULT
#

module "mocker_dev_secrets" {

  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_mocker_key_vault_resource_group
  key_vault_name = local.dev_mocker_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url"
  ]
}

#
# UAT MOCKER KEYVAULT
#

#module "mocker_uat_secrets" {
#  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"
#
#  providers = {
#    azurerm = azurerm.uat
#  }
#
#  resource_group = local.uat_mocker_key_vault_resource_group
#  key_vault_name = local.uat_mocker_key_vault_name
#
#  secrets = [
#    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
#    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
#    "pagopa-u-weu-uat-aks-apiserver-url"
#  ]
#}
