
module "secrets" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v2.0.4"

  resource_group = "io-p-rg-operations"
  key_vault_name = "io-p-kv-azuredevops"

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
    "UAT-CHECKOUT-CAPTCHA-ID",
    "PROD-CHECKOUT-CAPTCHA-ID",
    "DEV-SIA-DOCKER-REGISTRY-PWD",
    "UAT-SIA-DOCKER-REGISTRY-PWD",
    "PROD-SIA-DOCKER-REGISTRY-PWD",
    "DEV-APICONFIG-CLIENT-ID",
    "UAT-APICONFIG-CLIENT-ID",
    "PROD-APICONFIG-CLIENT-ID",
    "DEV-APICONFIG-CLIENT-SECRECT",
    "UAT-APICONFIG-CLIENT-SECRECT",
    "PROD-APICONFIG-CLIENT-SECRECT",
    "DEV-APICONFIG-BE-CLIENT-ID",
    "UAT-APICONFIG-BE-CLIENT-ID",
    "PROD-APICONFIG-BE-CLIENT-ID",
    "DEV-BUYERBANKS-API-KEY",
    "UAT-BUYERBANKS-API-KEY",
    "PROD-BUYERBANKS-API-KEY"
  ]
}
