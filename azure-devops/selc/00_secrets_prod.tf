#
# PROD KEYVAULT
#

module "secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = local.prod_key_vault_resource_group
  key_vault_name = local.prod_key_vault_azdo_name

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
    "DEV_AZURE_CLIENT_SECRET",
    "UAT_AZURE_CLIENT_SECRET",
    "PROD_AZURE_CLIENT_SECRET",
    "DEV_AZURE_CLIENT_ID",
    "UAT_AZURE_CLIENT_ID",
    "PROD_AZURE_CLIENT_ID",
    "DEV_SELC_APIM_EXTERNAL_API_KEY",
    "UAT_SELC_APIM_EXTERNAL_API_KEY",
    "PROD_SELC_APIM_EXTERNAL_API_KEY",
  ]
}
