data "azuredevops_project" "pagopa-projects" {
  name = "pagoPA-projects"
}

#
# ⛩ Service connections Azure
#

# 🟢 DEV service connection
resource "azuredevops_serviceendpoint_azurerm" "DEV-SERVICE-CONN" {
  depends_on = [data.azuredevops_project.pagopa-projects]

  project_id                = data.azuredevops_project.pagopa-projects.id
  service_endpoint_name     = "${var.dev_subscription_name}-SERVICE-CONN-RECEIPT"
  description               = "${var.dev_subscription_name} Service connection"
  azurerm_subscription_name = var.dev_subscription_name
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
}

# 🟨 UAT service connection
resource "azuredevops_serviceendpoint_azurerm" "UAT-SERVICE-CONN" {
  depends_on = [data.azuredevops_project.pagopa-projects]

  project_id                = data.azuredevops_project.pagopa-projects.id
  service_endpoint_name     = "${var.uat_subscription_name}-SERVICE-CONN-RECEIPT"
  description               = "${var.uat_subscription_name} Service connection"
  azurerm_subscription_name = var.uat_subscription_name
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
}
