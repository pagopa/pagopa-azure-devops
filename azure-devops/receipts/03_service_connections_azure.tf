data "azuredevops_project" "pagopa-projects" {
  name = "pagoPA-projects"
}

#
# ⛩ Service connections Azure
#

data "azuredevops_serviceendpoint_azurerm" "DEV-AZURERM-SERVICE-CONN" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.dev_azurerm_endpoint_name
}

data "azuredevops_serviceendpoint_azurerm" "UAT-AZURERM-SERVICE-CONN" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.uat_azurerm_endpoint_name
}
