#
# ⛩ Service connections Azure
#

# 🟢 DEV service connection
resource "azuredevops_serviceendpoint_azurerm" "DEV-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "${var.dev_subscription_name}-SERVICE-CONN"
  description               = "${var.dev_subscription_name} Service connection"
  azurerm_subscription_name = var.dev_subscription_name
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
}

# 🟨 UAT service connection
resource "azuredevops_serviceendpoint_azurerm" "UAT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "${var.uat_subscription_name}-SERVICE-CONN"
  description               = "${var.uat_subscription_name} Service connection"
  azurerm_subscription_name = var.uat_subscription_name
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
}

# 🛑 PROD service connection
resource "azuredevops_serviceendpoint_azurerm" "PROD-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "${var.prod_subscription_name}-SERVICE-CONN"
  description               = "${var.prod_subscription_name} Service connection"
  azurerm_subscription_name = var.prod_subscription_name
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
}
