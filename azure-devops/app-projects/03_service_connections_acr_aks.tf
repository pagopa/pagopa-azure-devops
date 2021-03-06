# 🟢 DEV service connection for azure container registry for AKS
resource "azuredevops_serviceendpoint_azurecr" "acr_aks_dev" {
  depends_on = [azuredevops_project.project]

  project_id     = azuredevops_project.project.id
  resource_group = local.aks_cr_rg_name_dev

  service_endpoint_name = local.srv_endpoint_name_aks_cr_dev
  azurecr_name          = local.aks_cr_name_dev

  azurecr_subscription_name = var.dev_subscription_name
  azurecr_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurecr_subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
}

# 🟨 UAT service connection for azure container registry for AKS
resource "azuredevops_serviceendpoint_azurecr" "acr_aks_uat" {
  depends_on = [azuredevops_project.project]

  service_endpoint_name = local.srv_endpoint_name_aks_cr_uat
  azurecr_name          = local.aks_cr_name_uat

  project_id     = azuredevops_project.project.id
  resource_group = local.aks_cr_rg_name_uat

  azurecr_subscription_name = var.uat_subscription_name
  azurecr_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurecr_subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
}

# 🛑 PROD service connection for azure container registry for AKS
resource "azuredevops_serviceendpoint_azurecr" "acr_aks_prod" {
  depends_on = [azuredevops_project.project]

  service_endpoint_name = local.srv_endpoint_name_aks_cr_prod
  azurecr_name          = local.aks_cr_name_prod

  project_id     = azuredevops_project.project.id
  resource_group = local.aks_cr_rg_name_prod

  azurecr_subscription_name = var.prod_subscription_name
  azurecr_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurecr_subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
}
