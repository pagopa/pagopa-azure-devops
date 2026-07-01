#
# ACR
#
data "azuredevops_serviceendpoint_azurecr" "dev_weu_workload_identity" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.acr_weu_service_connection_workload_identity_dev
}

data "azuredevops_serviceendpoint_azurecr" "uat_weu_workload_identity" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.acr_weu_service_connection_workload_identity_uat
}

data "azuredevops_serviceendpoint_azurecr" "prod_weu_workload_identity" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.acr_weu_service_connection_workload_identity_prod
}

data "azurerm_user_assigned_identity" "dev_weu_nodo_workload_identity" {
  name                = "nodo-workload-identity"
  resource_group_name = "${var.aks_dev_platform_name}-rg"

}

data "azurerm_user_assigned_identity" "uat_weu_nodo_workload_identity" {
  name                = "nodo-workload-identity"
  resource_group_name = "${var.aks_uat_platform_name}-rg"

}
