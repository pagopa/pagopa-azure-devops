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

data "azuredevops_serviceendpoint_azurerm" "prod" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_prod_azurerm_name
}

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

data "azuredevops_serviceendpoint_azurecr" "prod" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = var.service_connection_prod_acr_name
}

#
# Kubernetes
#
resource "azuredevops_serviceendpoint_kubernetes" "aks_dev" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_dev
  apiserver_url         = module.checkout_dev_secrets.values["pagopa-d-weu-dev-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.checkout_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-token"].value
    ca_cert = module.checkout_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-cacrt"].value
  }
}

resource "azuredevops_serviceendpoint_kubernetes" "aks_uat" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_uat
  apiserver_url         = module.checkout_uat_secrets.values["pagopa-u-weu-uat-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.checkout_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-token"].value
    ca_cert = module.checkout_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-cacrt"].value
  }
}

# resource "azuredevops_serviceendpoint_kubernetes" "aks_prod" {
#   depends_on            = [data.azuredevops_project.project]
#   project_id            = data.azuredevops_project.project.id
#   service_endpoint_name = local.srv_endpoint_name_aks_prod
#   apiserver_url         = module.checkout_prod_secrets.values["pagopa-p-weu-prod-aks-apiserver-url"].value
#   authorization_type    = "ServiceAccount"
#   service_account {
#     # base64 values
#     token   = module.checkout_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-token"].value
#     ca_cert = module.checkout_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value
#   }
# }

