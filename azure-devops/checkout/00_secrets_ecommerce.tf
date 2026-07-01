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

# module "ecommerce_uat_secrets" {
#
#   providers = {
#     azurerm = azurerm.uat
#   }
#
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.42.3"
#
#   resource_group = local.uat_ecommerce_key_vault_resource_group
#   key_vault_name = local.uat_ecommerce_key_vault_name
#
#   secrets = [
#     "npg-api-key",
#   ]
# }

# module "ecommerce_prod_secrets" {
#
#   providers = {
#     azurerm = azurerm.prod
#   }
#
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.42.3"
#
#   resource_group = local.prod_ecommerce_key_vault_resource_group
#   key_vault_name = local.prod_ecommerce_key_vault_name
#
#   secrets = [
#     "npg-api-key",
#   ]
# }
