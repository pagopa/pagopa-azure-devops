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
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
}

# 🟨 UAT service connection
resource "azuredevops_serviceendpoint_azurerm" "UAT-SERVICE-CONN" {
  depends_on = [data.azuredevops_project.pagopa-projects]

  project_id                = data.azuredevops_project.pagopa-projects.id
  service_endpoint_name     = "${var.uat_subscription_name}-SERVICE-CONN-RECEIPT"
  description               = "${var.uat_subscription_name} Service connection"
  azurerm_subscription_name = var.uat_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
}
