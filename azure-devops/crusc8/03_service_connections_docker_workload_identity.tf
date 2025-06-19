### ⚠️ the workload identities was created manually because there are a problem
### with the provider and the docker@2 plugin for azdo

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

#
# 🇮🇹 Italy Workload identity
#

data "azuredevops_serviceendpoint_azurecr" "dev_ita_workload_identity" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.acr_ita_service_connection_workload_identity_dev
}

data "azuredevops_serviceendpoint_azurecr" "uat_ita_workload_identity" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.acr_ita_service_connection_workload_identity_uat
}

data "azuredevops_serviceendpoint_azurecr" "prod_ita_workload_identity" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.acr_ita_service_connection_workload_identity_prod
}
