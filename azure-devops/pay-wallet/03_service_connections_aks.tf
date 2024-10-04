resource "azuredevops_serviceendpoint_kubernetes" "aks_dev" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_dev
  apiserver_url         = module.wallet_dev_secrets.values["pagopa-d-itn-dev-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.wallet_dev_secrets.values["pagopa-d-itn-dev-aks-azure-devops-sa-token"].value
    ca_cert = module.wallet_dev_secrets.values["pagopa-d-itn-dev-aks-azure-devops-sa-cacrt"].value
  }
}

resource "azuredevops_serviceendpoint_kubernetes" "aks_uat" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_uat
  apiserver_url         = module.wallet_uat_secrets.values["pagopa-u-itn-uat-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.wallet_uat_secrets.values["pagopa-u-itn-uat-aks-azure-devops-sa-token"].value
    ca_cert = module.wallet_uat_secrets.values["pagopa-u-itn-uat-aks-azure-devops-sa-cacrt"].value
  }
}

resource "azuredevops_serviceendpoint_kubernetes" "aks_prod" {
  depends_on            = [data.azuredevops_project.project]
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = local.srv_endpoint_name_aks_prod
  apiserver_url         = module.wallet_prod_secrets.values["pagopa-p-itn-prod-aks-apiserver-url"].value
  authorization_type    = "ServiceAccount"
  service_account {
    # base64 values
    token   = module.wallet_prod_secrets.values["pagopa-p-itn-prod-aks-azure-devops-sa-token"].value
    ca_cert = module.wallet_prod_secrets.values["pagopa-p-itn-prod-aks-azure-devops-sa-cacrt"].value
  }
}
