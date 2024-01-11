#
# PROD KEYVAULT
#

module "secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"

  resource_group = local.prod_key_vault_resource_group
  key_vault_name = local.prod_key_vault_azdo_name

  secrets = [
    "DANGER-GITHUB-API-TOKEN",
    "azure-devops-github-ro-TOKEN",
    "azure-devops-github-rw-TOKEN",
    "azure-devops-github-pr-TOKEN",
    "azure-devops-github-EMAIL",
    "azure-devops-github-USERNAME",
    "CHECKOUT-TEST-V1-SUBSCRIPTION-KEY",
    "CHECKOUT-TEST-V2-SUBSCRIPTION-KEY",
    "DEV-CHECKOUT-CAPTCHA-ID",
    "UAT-CHECKOUT-CAPTCHA-ID",
    "PROD-CHECKOUT-CAPTCHA-ID",
    "checkout-test-npg-api-key"
  ]
}
