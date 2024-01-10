#
# ⛩ Service connection 2 🔐 KV@UAT 🛑
#
#tfsec:ignore:GEN003
module "UAT-APPINSIGHTS-SERVICE-CONN" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.1.5"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = data.azuredevops_project.project.id
  name              = "${local.prefix}-u-${local.domain}-appinsights"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name = var.uat_subscription_name

  location = local.location
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
