#
# ⛩ Service connection 2 🔐 KV@DEV 🛑
#
#tfsec:ignore:GEN003
module "DEV-APPINSIGHTS-SERVICE-CONN" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.2.1"
  providers = {
    azurerm = azurerm.dev
  }

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-${local.domain}-d-appinsights-azdo"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  subscription_name = var.dev_subscription_name

  location            = local.location
  resource_group_name = local.dev_identity_rg_name
}

data "azurerm_application_insights" "application_insights_dev" {
  provider            = azurerm.dev
  name                = local.dev_appinsights_name
  resource_group_name = local.dev_appinsights_resource_group
}

resource "azurerm_role_assignment" "appinsights_component_contributor_dev" {
  provider             = azurerm.dev
  scope                = data.azurerm_application_insights.application_insights_dev.id
  role_definition_name = "Application Insights Component Contributor"
  principal_id         = module.DEV-APPINSIGHTS-SERVICE-CONN.service_principal_object_id
}

#
# ⛩ Service connection 2 🔐 KV@UAT 🛑
#
#tfsec:ignore:GEN003
module "UAT-APPINSIGHTS-SERVICE-CONN" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.2.1"
  providers = {
    azurerm = azurerm.uat
  }

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-${local.domain}-u-appinsights-azdo"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name = var.uat_subscription_name

  location            = local.location
  resource_group_name = local.uat_identity_rg_name
}

data "azurerm_application_insights" "application_insights_uat" {
  provider            = azurerm.uat
  name                = local.uat_appinsights_name
  resource_group_name = local.uat_appinsights_resource_group
}

resource "azurerm_role_assignment" "appinsights_component_contributor_uat" {
  provider             = azurerm.uat
  scope                = data.azurerm_application_insights.application_insights_uat.id
  role_definition_name = "Application Insights Component Contributor"
  principal_id         = module.UAT-APPINSIGHTS-SERVICE-CONN.service_principal_object_id
}

#
# ⛩ Service connection 2 🔐 KV@OPROD 🛑
#
#tfsec:ignore:GEN003
module "PROD-APPINSIGHTS-SERVICE-CONN" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.2.1"
  providers = {
    azurerm = azurerm.prod
  }

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-${local.domain}-p-appinsights-azdo"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name = var.prod_subscription_name

  location            = local.location
  resource_group_name = local.prod_identity_rg_name
}

data "azurerm_application_insights" "application_insights_prod" {
  provider            = azurerm.prod
  name                = local.prod_appinsights_name
  resource_group_name = local.prod_appinsights_resource_group
}

resource "azurerm_role_assignment" "appinsights_component_contributor_prod" {
  provider             = azurerm.prod
  scope                = data.azurerm_application_insights.application_insights_prod.id
  role_definition_name = "Application Insights Component Contributor"
  principal_id         = module.PROD-APPINSIGHTS-SERVICE-CONN.service_principal_object_id
}
