#
# ⛩ Service connection 2 🔐 KV@OPROD 🛑
#
#tfsec:ignore:GEN003
module "PROD-APPINSIGHTS-SERVICE-CONN" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.1.5"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = data.azuredevops_project.project.id
  name              = "${local.prefix}-p-${local.domain}-appinsights"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name = var.prod_subscription_name
  location = local.location
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
