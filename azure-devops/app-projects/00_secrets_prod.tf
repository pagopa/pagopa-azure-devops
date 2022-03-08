module "secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.5"

  resource_group = local.prod_key_vault_resource_group
  key_vault_name = local.prod_key_vault_name

  secrets = [
    "azure-devops-github-ro-TOKEN",
    "azure-devops-github-pr-TOKEN",
    "azure-devops-github-EMAIL",
    "azure-devops-github-USERNAME",
    "TENANTID",
    "DEV-SUBSCRIPTION-ID",
    "UAT-SUBSCRIPTION-ID",
    "PROD-SUBSCRIPTION-ID",
  ]
}

# module "secrets_prod" {
#   source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.5"
#   providers = {
#     azurerm = azurerm.prod
#   }

#   resource_group = local.prod_key_vault_resource_group
#   key_vault_name = local.prod_key_vault_name

#   secrets = [
#     "aks-apiserver-url",
#     "aks-azure-devops-sa-cacrt",
#     "aks-azure-devops-sa-token",
#   ]
# }
