#
# PROD ECOMMERCE KEYVAULT
#

module "ecommerce_secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.dev_ecommerce_key_vault_resource_group
  key_vault_name = local.dev_ecommerce_key_vault_azdo_name

  secrets = [
    "DANGER-GITHUB-API-TOKEN",
    "azure-devops-github-ro-TOKEN",
    "azure-devops-github-rw-TOKEN",
    "azure-devops-github-pr-TOKEN",
    "azure-devops-github-EMAIL",
    "azure-devops-github-USERNAME",
    "TENANTID",
    "DEV-SUBSCRIPTION-ID",
    "UAT-SUBSCRIPTION-ID",
    "PROD-SUBSCRIPTION-ID",
    "aks-azure-devops-sa-token-dev",
    "aks-azure-devops-sa-token-uat",
    "aks-azure-devops-sa-token-prod",
    "aks-azure-devops-sa-cacrt-dev",
    "aks-azure-devops-sa-cacrt-uat",
    "aks-azure-devops-sa-cacrt-prod"
  ]
}
