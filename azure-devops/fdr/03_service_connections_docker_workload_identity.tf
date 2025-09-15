#
# 🇪🇺 WEU
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
