#
# pagopa KEYVAULT
#

module "dev_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.48.0"

  for_each = { for d in local.definitions : d.name => d if contains(d.envs, "d") && try(d.kv_name, "") != "" }

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = format(each.value.rg_name, "d")
  key_vault_name = format(each.value.kv_name, "d")

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url"
  ]
}

module "uat_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.48.0"

  for_each = { for d in local.definitions : d.name => d if contains(d.envs, "u") && try(d.kv_name, "") != "" }

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = format(each.value.rg_name, "u")
  key_vault_name = format(each.value.kv_name, "u")


  secrets = [
    "pagopa-d-weu-uat-aks-azure-devops-sa-token",
    "pagopa-d-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-uat-aks-apiserver-url"
  ]
}

module "prod_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.48.0"

  for_each = { for d in local.definitions : d.name => d if contains(d.envs, "p") && try(d.kv_name, "") != "" }

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = format(each.value.rg_name, "p")
  key_vault_name = format(each.value.kv_name, "p")


  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-d-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-prod-aks-apiserver-url"
  ]
}
