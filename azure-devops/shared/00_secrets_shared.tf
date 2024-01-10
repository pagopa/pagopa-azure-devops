#
# PROD GPS KEYVAULT
#

module "shared_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  resource_group = local.dev_shared_key_vault_resource_group
  key_vault_name = local.dev_shared_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url",
    "poc-d-reporting-enrollment-subscription-key",
    "auth-d-cosmos-uri",
    "auth-d-cosmos-key",
    "auth-d-cosmos-connection-string",
    "auth-d-integrationtest-external-subkey",
    "auth-d-integrationtest-valid-subkey",
    "auth-d-integrationtest-invalid-subkey",
    "pdf-engine-d-perftest-subkey"
  ]
}

module "shared_uat_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_shared_key_vault_resource_group
  key_vault_name = local.uat_shared_key_vault_name

  secrets = [
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url",
    # "poc-u-reporting-enrollment-subscription-key",
    "auth-u-cosmos-uri",
    "auth-u-cosmos-key",
    "auth-u-cosmos-connection-string",
    "auth-u-integrationtest-external-subkey",
    "auth-u-integrationtest-valid-subkey",
    "auth-u-integrationtest-invalid-subkey",
    "pdf-engine-u-perftest-subkey",
    "pdf-engine-node-u-perftest-subkey"
  ]
}

module "shared_prod_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_shared_key_vault_resource_group
  key_vault_name = local.prod_shared_key_vault_name

  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-weu-prod-aks-apiserver-url",
    # "auth-p-cosmos-uri",
    # "auth-p-cosmos-key",
    # "auth-p-cosmos-connection-string"
  ]
}
