#
# printit KEYVAULT
#

module "printit_dev_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.13.0"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_printit_key_vault_resource_group
  key_vault_name = local.dev_printit_key_vault_name

  secrets = [
    "pagopa-d-itn-dev-aks-azure-devops-sa-token",
    "pagopa-d-itn-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-itn-dev-aks-apiserver-url"
  ]
}

module "printit_uat_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.13.0"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_printit_key_vault_resource_group
  key_vault_name = local.uat_printit_key_vault_name

  secrets = [
    "pagopa-u-itn-uat-aks-azure-devops-sa-token",
    "pagopa-u-itn-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-itn-uat-aks-apiserver-url"
  ]
}

module "printit_prod_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.13.0"

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_printit_key_vault_resource_group
  key_vault_name = local.prod_printit_key_vault_name

  secrets = [
    "pagopa-p-itn-prod-aks-azure-devops-sa-token",
    "pagopa-p-itn-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-itn-prod-aks-apiserver-url"
  ]
}
