#
# ⛩ Service connections Azure
#

module "DEV-AZURERM-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.1.5"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-d-${local.domain}-azdo-azurerm"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  subscription_name = var.dev_subscription_name

  location            = var.location
  resource_group_name = local.dev_identity_rg_name
}

resource "azurerm_role_assignment" "dev_azurerm" {
  scope                = data.azurerm_subscriptions.dev.subscriptions[0].id
  role_definition_name = "Contributor"
  principal_id         = module.DEV-AZURERM-SERVICE-CONN.identity_principal_id
}

#
# UAT
#
module "UAT-AZURERM-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.1.5"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-u-${local.domain}-azdo-azurerm"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name = var.uat_subscription_name

  location            = var.location
  resource_group_name = local.uat_identity_rg_name
}

resource "azurerm_role_assignment" "uat_azurerm" {
  scope                = data.azurerm_subscriptions.uat.subscriptions[0].id
  role_definition_name = "Contributor"
  principal_id         = module.UAT-AZURERM-SERVICE-CONN.identity_principal_id
}

#
# PROD
#
module "PROD-AZURERM-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.1.5"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name              = "${local.prefix}-p-${local.domain}-azdo-azurerm"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name = var.prod_subscription_name

  location            = var.location
  resource_group_name = local.prod_identity_rg_name
}

resource "azurerm_role_assignment" "prod_azurerm" {
  scope                = data.azurerm_subscriptions.prod.subscriptions[0].id
  role_definition_name = "Contributor"
  principal_id         = module.PROD-AZURERM-SERVICE-CONN.identity_principal_id
}
