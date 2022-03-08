module "secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v1.0.80"

  resource_group = local.prod_key_vault_resource_group
  key_vault_name = local.prod_key_vault_name

  secrets = [
    "azure-devops-github-ro-TOKEN",
    "azure-devops-github-pr-TOKEN",
    "TENANTID",
    "DEV-SUBSCRIPTION-ID",
    "UAT-SUBSCRIPTION-ID",
    "PROD-SUBSCRIPTION-ID",
  ]
}
