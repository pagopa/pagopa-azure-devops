resource "azuredevops_serviceendpoint_kubernetes" "aks_dev" {
  depends_on            = [azuredevops_project.project]
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "${var.prefix}-aks-dev"
  apiserver_url         = module.secrets.values["aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.secrets.values["aks-azure-devops-sa-token-dev"].value
    ca_cert = module.secrets.values["aks-azure-devops-sa-cacrt-dev"].value
  }
}

resource "azuredevops_serviceendpoint_kubernetes" "aks_uat" {
  depends_on            = [azuredevops_project.project]
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "${var.prefix}-aks-uat"
  apiserver_url         = module.secrets.values["aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.secrets.values["aks-azure-devops-sa-token-uat"].value
    ca_cert = module.secrets.values["aks-azure-devops-sa-cacrt-uat"].value
  }
}

resource "azuredevops_serviceendpoint_kubernetes" "aks_prod" {
  depends_on            = [azuredevops_project.project]
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "${var.prefix}-aks-prod"
  apiserver_url         = module.secrets.values["aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.secrets.values["aks-azure-devops-sa-token-prod"].value
    ca_cert = module.secrets.values["aks-azure-devops-sa-cacrt-prod"].value
  }
}