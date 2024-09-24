#
# PROD KEYVAULT
#

module "secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v8.22.0"

  resource_group = local.prod_key_vault_resource_group
  key_vault_name = local.prod_key_vault_azdo_name

  secrets = [
    "DANGER-GITHUB-API-TOKEN",
    "azure-devops-github-ro-TOKEN",
    "azure-devops-github-rw-TOKEN",
    "azure-devops-github-pr-TOKEN",
    "azure-devops-github-EMAIL",
    "azure-devops-github-USERNAME",
  ]
}

# data "azurerm_subscriptions" "prod" {
#   display_name_prefix = local.prod_subscription_name
# }

# data "azurerm_subscriptions" "uat" {
#   display_name_prefix = local.uat_subscription_name
# }

data "azurerm_subscriptions" "dev" {
  display_name_prefix = local.dev_subscription_name
}
