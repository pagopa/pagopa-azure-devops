module "printit_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.67.1"

  resource_group = local.dev_printit_key_vault_resource_group
  key_vault_name = local.dev_printit_key_vault_name

  secrets = [
    "institutions-storage-account-connection-string",
    "notices-storage-account-connection-string",
    "notices-mongo-connection-string",
  ]
}

module "printit_uat_secrets" {

  providers = {
    azurerm = azurerm.uat
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.67.1"

  resource_group = local.uat_printit_key_vault_resource_group
  key_vault_name = local.uat_printit_key_vault_name

  secrets = [
    "institutions-storage-account-connection-string",
    "notices-storage-account-connection-string",
    "notices-mongo-connection-string",
  ]
}

module "printit_prod_secrets" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.67.1"

  resource_group = local.prod_printit_key_vault_resource_group
  key_vault_name = local.prod_printit_key_vault_name

  secrets = [
    "institutions-storage-account-connection-string",
    "notices-storage-account-connection-string",
    "notices-mongo-connection-string",
  ]
}


module "general_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.67.1"

  resource_group = "pagopa-d-sec-rg"
  key_vault_name = "pagopa-d-kv"

  secrets = [
    "integration-test-subkey",
  ]
}

module "general_uat_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.67.1"

  resource_group = "pagopa-u-sec-rg"
  key_vault_name = "pagopa-u-kv"

  secrets = [
    "integration-test-subkey",
  ]
}
