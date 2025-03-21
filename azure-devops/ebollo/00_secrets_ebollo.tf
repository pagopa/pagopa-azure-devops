module "ebollo_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  resource_group = local.dev_ebollo_key_vault_resource_group
  key_vault_name = local.dev_ebollo_key_vault_name

  secrets = [
    "pagopa-d-itn-dev-aks-azure-devops-sa-token",
    "pagopa-d-itn-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-itn-dev-aks-apiserver-url",
    "apikey-gps-mbd-integration-test",
    "apikey-mbd-integration-test"
  ]
}

module "ebollo_uat_secrets" {

  providers = {
    azurerm = azurerm.uat
  }

  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  resource_group = local.uat_ebollo_key_vault_resource_group
  key_vault_name = local.uat_ebollo_key_vault_name

  secrets = [
    "pagopa-u-itn-uat-aks-azure-devops-sa-token",
    "pagopa-u-itn-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-itn-uat-aks-apiserver-url",
    "apikey-gps-mbd-integration-test",
    "apikey-mbd-integration-test"
  ]
}

module "ebollo_prod_secrets" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.22.0"

  resource_group = local.prod_ebollo_key_vault_resource_group
  key_vault_name = local.prod_ebollo_key_vault_name

  secrets = [
    "pagopa-p-itn-prod-aks-azure-devops-sa-token",
    "pagopa-p-itn-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-itn-prod-aks-apiserver-url",
  ]
}


module "general_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.22.0"

  resource_group = "pagopa-d-sec-rg"
  key_vault_name = "pagopa-d-kv"

  secrets = [
    "integration-test-subkey",
  ]
}

module "general_uat_secrets" {

  providers = {
    azurerm = azurerm.uat
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.22.0"

  resource_group = "pagopa-u-sec-rg"
  key_vault_name = "pagopa-u-kv"

  secrets = [
    "integration-test-subkey",
  ]
}

module "general_prod_secrets" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.22.0"

  resource_group = "pagopa-p-sec-rg"
  key_vault_name = "pagopa-p-kv"

  secrets = [
  ]
}
