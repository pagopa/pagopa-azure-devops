#
# PROD KEYVAULT
#

module "secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

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
  ]
}
