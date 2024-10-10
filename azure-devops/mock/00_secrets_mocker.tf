#
# DEV MOCK KEYVAULT
#

module "mock_dev_secrets" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_mock_key_vault_resource_group
  key_vault_name = local.dev_mock_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url"
  ]
}

#
# UAT MOCK KEYVAULT
#

#module "mock_uat_secrets" {
#  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"
#
#  providers = {
#    azurerm = azurerm.uat
#  }
#
#  resource_group = local.uat_mock_key_vault_resource_group
#  key_vault_name = local.uat_mock_key_vault_name
#
#  secrets = [
#    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
#    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
#    "pagopa-u-weu-uat-aks-apiserver-url"
#  ]
#}
