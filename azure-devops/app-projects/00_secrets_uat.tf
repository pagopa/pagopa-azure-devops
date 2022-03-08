# module "secrets_uat" {
#   source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.5"
#   providers = {
#     azurerm = azurerm.uat
#   }

#   resource_group = local.uat_key_vault_resource_group
#   key_vault_name = local.uat_key_vault_name

#   secrets = [
#     "aks-apiserver-url",
#     "aks-azure-devops-sa-cacrt",
#     "aks-azure-devops-sa-token",
#   ]
# }
