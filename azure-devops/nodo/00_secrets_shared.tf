#
# DEV SHARED KEYVAULT
#

module "shared_dev_secrets" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_shared_key_vault_resource_group
  key_vault_name = local.dev_shared_key_vault_name

  secrets = [
    "pagopa-platform-domain-github-bot-email",
    "pagopa-platform-domain-github-bot-username"
  ]
}

#
# UAT SHARED KEYVAULT
#

module "shared_uat_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_shared_key_vault_resource_group
  key_vault_name = local.uat_shared_key_vault_name

  secrets = [
    "pagopa-platform-domain-github-bot-email",
    "pagopa-platform-domain-github-bot-username"
  ]
}
