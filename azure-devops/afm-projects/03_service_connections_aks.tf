resource "azuredevops_serviceendpoint_kubernetes" "aks_dev" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_dev
  apiserver_url         = module.afm_dev_secrets.values["pagopa-d-weu-dev-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.afm_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-token"].value
    ca_cert = module.afm_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-cacrt"].value
  }
}

# resource "azuredevops_serviceendpoint_kubernetes" "aks_uat" {
#   depends_on            = [azuredevops_project.project]
#   project_id            = azuredevops_project.project.id
#   service_endpoint_name = local.srv_endpoint_name_aks_uat
#   apiserver_url         = module.secrets.values["aks-apiserver-url"].value
#   authorization_type    = "ServiceAccount"
#   service_account {
#     # base64 values
#     token   = module.secrets.values["aks-azure-devops-sa-token-uat"].value
#     ca_cert = module.secrets.values["aks-azure-devops-sa-cacrt-uat"].value
#   }
# }

# resource "azuredevops_serviceendpoint_kubernetes" "aks_prod" {
#   depends_on            = [azuredevops_project.project]
#   project_id            = azuredevops_project.project.id
#   service_endpoint_name = local.srv_endpoint_name_aks_prod
#   apiserver_url         = module.secrets.values["aks-apiserver-url"].value
#   authorization_type    = "ServiceAccount"
#   service_account {
#     # base64 values
#     token   = module.secrets.values["aks-azure-devops-sa-token-prod"].value
#     ca_cert = module.secrets.values["aks-azure-devops-sa-cacrt-prod"].value
#   }
# }
