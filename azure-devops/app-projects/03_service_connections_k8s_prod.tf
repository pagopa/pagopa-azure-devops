# # 🛑 PROD service connection for azure kubernetes service
# resource "azuredevops_serviceendpoint_kubernetes" "aks-prod" {
#   depends_on            = [azuredevops_project.project]
#   project_id            = azuredevops_project.project.id
#   service_endpoint_name = "${local.prefix}-aks-prod"
#   apiserver_url         = module.secrets_prod.values["aks-apiserver-url"].value
#   authorization_type    = "ServiceAccount"
#   service_account {
#     # base64 values
#     token   = module.secrets_prod.values["aks-azure-devops-sa-token"].value
#     ca_cert = module.secrets_prod.values["aks-azure-devops-sa-cacrt"].value
#   }
# }
