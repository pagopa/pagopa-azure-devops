#
# PROD ECOMMERCE KEYVAULT
#

module "ecommerce_dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"


  resource_group = local.dev_ecommerce_key_vault_resource_group
  key_vault_name = local.dev_ecommerce_key_vault_name

  secrets = [
    "pagopa-d-weu-dev-aks-azure-devops-sa-token",
    "pagopa-d-weu-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-weu-dev-aks-apiserver-url",
    "notifications-service-testing-api-key",
    "notifications-service-testing-mail",
    "helpdesk-service-testing-api-key",
    "helpdesk-service-testing-email",
    "helpdesk-service-testing-fiscalCode",
    "wallet-token-test-key",
    "helpdesk-ecommerce-commands-testing-api-key",
    "helpdesk-service-testing-email-history",
    "ecommerce-jwt-issuer-service-primary-api-key",
    "ecommerce-jwt-issuer-service-secondary-api-key",
    "mongo-ecommerce-password",
    "ecommerce-storage-transient-connection-string",
    "checkout-payment-methods-handler-api-key",
    "io-payment-methods-handler-api-key"
  ]
}

module "ecommerce_uat_secrets" {

  providers = {
    azurerm = azurerm.uat
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"

  resource_group = local.uat_ecommerce_key_vault_resource_group
  key_vault_name = local.uat_ecommerce_key_vault_name

  secrets = [
    "pagopa-u-weu-uat-aks-azure-devops-sa-token",
    "pagopa-u-weu-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-weu-uat-aks-apiserver-url",
    "ecommerce-load-test-subscription-key",
    "notifications-service-testing-api-key",
    "notifications-service-testing-mail",
    "helpdesk-service-testing-api-key",
    "helpdesk-service-testing-email",
    "helpdesk-service-testing-fiscalCode",
    "wallet-token-test-key",
    "helpdesk-ecommerce-commands-testing-api-key",
    "ecommerce-jwt-issuer-service-primary-api-key",
    "ecommerce-jwt-issuer-service-secondary-api-key",
    "mongo-ecommerce-password",
    "ecommerce-storage-transient-connection-string",
    "checkout-payment-methods-handler-api-key",
    "io-payment-methods-handler-api-key"
  ]
}

module "ecommerce_prod_secrets" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.39.0"

  resource_group = local.prod_ecommerce_key_vault_resource_group
  key_vault_name = local.prod_ecommerce_key_vault_name

  secrets = [
    "pagopa-p-weu-prod-aks-azure-devops-sa-token",
    "pagopa-p-weu-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-weu-prod-aks-apiserver-url",
    "touchpoint-mail",
    "ecommerce-event-dispatcher-service-primary-api-key",
    "ecommerce-event-dispatcher-service-secondary-api-key",
    "ecommerce-github-packages-read-bot-token"
  ]
}
