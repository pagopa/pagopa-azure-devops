# module "secrets_dev" {
#   source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.5"
#   providers = {
#     azurerm = azurerm.dev
#   }

#   resource_group = local.dev_key_vault_resource_group
#   key_vault_name = local.dev_key_vault_name

#   secrets = [
#     "aks-apiserver-url",
#     "aks-azure-devops-sa-cacrt",
#     "aks-azure-devops-sa-token",
#   ]
# }
