#
# PROD KEYVAULT
#

module "secrets" {

  source = "./.terraform/modules/__v3__/key_vault_secrets_query"


  resource_group = local.prod_key_vault_resource_group
  key_vault_name = local.prod_key_vault_azdo_name

  secrets = [
    "DANGER-GITHUB-API-TOKEN",
    "azure-devops-github-ro-TOKEN",
    "azure-devops-github-rw-TOKEN",
    "azure-devops-github-pr-TOKEN",
    "azure-devops-github-EMAIL",
    "azure-devops-github-USERNAME",
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
    "PROD-BUYERBANKS-API-KEY",
    "DEV-APD-SPRING-DATASOURCE-PWD",
    "UAT-APD-SPRING-DATASOURCE-PWD",
    "PROD-APD-SPRING-DATASOURCE-PWD",
    "assets-azure-storage-key",
    "DEV-PGS-MOCK-TEST-API-KEY",
    "DEV-PGS-TEST-API-KEY",
  ]
}

#
# PROD KEYVAULT CORE
#

module "pagopa_core_prod_secrets" {

  source = "./.terraform/modules/__v3__/key_vault_secrets_query"


  resource_group = local.prod_key_vault_resource_group
  key_vault_name = local.prod_key_vault_name

  secrets = [
    "tls-cert-diff-receiver-emails",
    "tls-cert-diff-sender-email",
    "tls-cert-diff-sender-email-app-pass",
  ]
}
