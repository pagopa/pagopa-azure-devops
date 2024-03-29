# DEV
module "selfcare_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  resource_group = local.dev_selfcare_key_vault_resource_group
  key_vault_name = local.dev_selfcare_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url",
    "pagopa-selfcare-d-azure-client-secret",
    "pagopa-selfcare-d-azure-client-id",
    "selfcare-d-apim-external-api-key",
  ]
}

# UAT
module "selfcare_uat_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_selfcare_key_vault_resource_group
  key_vault_name = local.uat_selfcare_key_vault_name

  secrets = [
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url",
    "pagopa-selfcare-u-azure-client-secret",
    "pagopa-selfcare-u-azure-client-id",
    "selfcare-u-apim-external-api-key",
  ]
}

# PROD
module "selfcare_prod_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_selfcare_key_vault_resource_group
  key_vault_name = local.prod_selfcare_key_vault_name

  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-weu-prod-aks-apiserver-url",
    "pagopa-selfcare-p-azure-client-secret",
    "pagopa-selfcare-p-azure-client-id",
    "selfcare-p-apim-external-api-key",
  ]
}
