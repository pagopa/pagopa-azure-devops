resource "azuredevops_serviceendpoint_kubernetes" "aks_dev_weu" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_dev
  apiserver_url         = module.nodo_dev_secrets.values["pagopa-d-weu-dev-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.nodo_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-token"].value
    ca_cert = module.nodo_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-cacrt"].value
  }
}
resource "azuredevops_serviceendpoint_kubernetes" "aks_dev_neu" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_dev
  apiserver_url         = module.nodo_dev_secrets.values["pagopa-d-neu-dev-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.nodo_dev_secrets.values["pagopa-d-neu-dev-aks-azure-devops-sa-token"].value
    ca_cert = module.nodo_dev_secrets.values["pagopa-d-neu-dev-aks-azure-devops-sa-cacrt"].value
  }
}

resource "azuredevops_serviceendpoint_kubernetes" "aks_uat_weu" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_uat
  apiserver_url         = module.nodo_uat_secrets.values["pagopa-u-weu-uat-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.nodo_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-token"].value
    ca_cert = module.nodo_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-cacrt"].value
  }
}

resource "azuredevops_serviceendpoint_kubernetes" "aks_uat_neu" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_uat
  apiserver_url         = module.nodo_uat_secrets.values["pagopa-u-neu-uat-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.nodo_uat_secrets.values["pagopa-u-neu-uat-aks-azure-devops-sa-token"].value
    ca_cert = module.nodo_uat_secrets.values["pagopa-u-neu-uat-aks-azure-devops-sa-cacrt"].value
  }
}


resource "azuredevops_serviceendpoint_kubernetes" "aks_prod_weu" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_prod
  apiserver_url         = module.nodo_prod_secrets.values["pagopa-p-weu-prod-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.nodo_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-token"].value
    ca_cert = module.nodo_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value
  }
}

resource "azuredevops_serviceendpoint_kubernetes" "aks_prod_neu" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_prod
  apiserver_url         = module.nodo_prod_secrets.values["pagopa-p-neu-prod-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.nodo_prod_secrets.values["pagopa-p-neu-prod-aks-azure-devops-sa-token"].value
    ca_cert = module.nodo_prod_secrets.values["pagopa-p-neu-prod-aks-azure-devops-sa-cacrt"].value
  }
}
