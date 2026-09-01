data "azuredevops_serviceendpoint_azurerm" "dev" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_dev_azurerm_name
}

data "azuredevops_serviceendpoint_azurerm" "uat" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_uat_azurerm_name
}

data "azuredevops_serviceendpoint_azurerm" "prod" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_prod_azurerm_name
}
