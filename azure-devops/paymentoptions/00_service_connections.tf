#
# GITHUB
#
data "azuredevops_serviceendpoint_github" "github_pr" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "io-azure-devops-github-pr"
}

data "azuredevops_serviceendpoint_github" "github_ro" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "io-azure-devops-github-ro"
}

data "azuredevops_serviceendpoint_github" "github_rw" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "io-azure-devops-github-rw"
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

# data "azuredevops_serviceendpoint_azurerm" "prod" {
#   project_id            = data.azuredevops_project.project.id
#   service_endpoint_name = var.service_connection_prod_azurerm_name
# }

#
# ACR
#
data "azuredevops_serviceendpoint_azurecr" "dev" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_dev_acr_name
}

data "azuredevops_serviceendpoint_azurecr" "uat" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_uat_acr_name
}

# data "azuredevops_serviceendpoint_azurecr" "prod" {
#   project_id            = data.azuredevops_project.project.id
#   service_endpoint_name = var.service_connection_prod_acr_name
# }
