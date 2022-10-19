##
## ⛩ Service connection 2 🔐 KV@OPROD 🛑
##
##tfsec:ignore:GEN003
#module "PROD-APPINSIGHTS-SERVICE-CONN" {
#  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.6.5"
#  providers = {
#    azurerm = azurerm.prod
#  }
#
#  project_id = data.azuredevops_project.project.id
#  #tfsec:ignore:general-secrets-no-plaintext-exposure
#  renew_token       = local.appinsights_renew_token
#  name              = "${local.prefix}-p-${local.domain}-appinsights"
#  tenant_id         = module.secrets.values["TENANTID"].value
#  subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
#  subscription_name = var.prod_subscription_name
#
#  credential_subcription              = var.prod_subscription_name
#  credential_key_vault_name           = local.prod_bizevents_key_vault_name
#  credential_key_vault_resource_group = local.prod_bizevents_key_vault_resource_group
#}
#
#data "azurerm_application_insights" "application_insights_prod" {
#  provider            = azurerm.prod
#  name                = local.prod_appinsights_name
#  resource_group_name = local.prod_appinsights_resource_group
#}
#
#resource "azurerm_role_assignment" "appinsights_component_contributor_prod" {
#  provider             = azurerm.prod
#  scope                = data.azurerm_application_insights.application_insights_prod.id
#  role_definition_name = "Application Insights Component Contributor"
#  principal_id         = module.PROD-APPINSIGHTS-SERVICE-CONN.service_principal_object_id
#}
