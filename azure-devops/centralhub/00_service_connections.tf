#
# GITHUB
#
resource "azuredevops_serviceendpoint_github" "github_centralhub" {
  depends_on = [data.azuredevops_project.project]

  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.centralhub_github_connection_name

  auth_personal {
    personal_access_token = module.centralhub_github_token.values["azure-devops-centralhub-github-token"].value
  }

  lifecycle {
    ignore_changes = [description, authorization]
  }
}

#
# AZURERM
#
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
