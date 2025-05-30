#
# ⛩ Service connections Azure
#

module "dev_azurerm_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name = "DEV-PAGOPA"

  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  subscription_name = var.dev_subscription_name

  location            = var.location
  resource_group_name = local.dev_identity_rg_name
}

resource "azurerm_role_assignment" "dev_azurerm" {
  scope                = data.azurerm_subscriptions.dev.subscriptions[0].id
  role_definition_name = "Contributor"
  principal_id         = module.dev_azurerm_service_conn.identity_principal_id
}

#
# UAT
#
module "uat_azurerm_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name = "UAT-PAGOPA"

  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name = var.uat_subscription_name

  location            = var.location
  resource_group_name = local.uat_identity_rg_name
}

resource "azurerm_role_assignment" "uat_azurerm" {
  scope                = data.azurerm_subscriptions.uat.subscriptions[0].id
  role_definition_name = "Contributor"
  principal_id         = module.uat_azurerm_service_conn.identity_principal_id
}

#
# PROD
#
module "prod_azurerm_service_conn" {
  depends_on = [azuredevops_project.project]
  source     = "./.terraform/modules/__azdo__/azuredevops_serviceendpoint_federated"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name = "PROD-PAGOPA"

  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name = var.prod_subscription_name

  location            = var.location
  resource_group_name = local.prod_identity_rg_name
}

resource "azurerm_role_assignment" "prod_azurerm" {
  scope                = data.azurerm_subscriptions.prod.subscriptions[0].id
  role_definition_name = "Contributor"
  principal_id         = module.prod_azurerm_service_conn.identity_principal_id
}
