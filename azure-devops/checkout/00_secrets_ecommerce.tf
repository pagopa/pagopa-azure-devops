#
# ECOMMERCE KEY VAULT
#

module "ecommerce_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.42.3"

  resource_group = local.dev_ecommerce_key_vault_resource_group
  key_vault_name = local.dev_ecommerce_key_vault_name

  secrets = [
    "npg-api-key",
  ]
}
