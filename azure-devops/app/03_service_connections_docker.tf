#
# 🇪🇺 WEU
#

# 🟢 DEV service connection for azure container registry
resource "azuredevops_serviceendpoint_azurecr" "acr_docker_registry_dev" {
  depends_on = [azuredevops_project.project]

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_rg_name_dev

  service_endpoint_name = local.srv_endpoint_name_docker_registry_dev
  azurecr_name          = local.docker_registry_name_dev

  azurecr_subscription_name = var.dev_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
}

# 🟨 UAT service connection for azure container registry
resource "azuredevops_serviceendpoint_azurecr" "acr_docker_registry_uat" {
  depends_on = [azuredevops_project.project]

  service_endpoint_name = local.srv_endpoint_name_docker_registry_uat
  azurecr_name          = local.docker_registry_name_uat

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_rg_name_uat

  azurecr_subscription_name = var.uat_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
}

# 🛑 PROD service connection for azure container registry
resource "azuredevops_serviceendpoint_azurecr" "acr_docker_registry_prod" {
  depends_on = [azuredevops_project.project]

  service_endpoint_name = local.srv_endpoint_name_docker_registry_prod
  azurecr_name          = local.docker_registry_name_prod

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_rg_name_prod

  azurecr_subscription_name = var.prod_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
}

#
# 🇮🇹 Italy
#

# 🟢 DEV service connection for AKS container registry in italy north
resource "azuredevops_serviceendpoint_azurecr" "aks_cr_itn_dev" {
  depends_on = [azuredevops_project.project]

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_italy_rg_name_dev

  service_endpoint_name = local.srv_endpoint_name_docker_registry_italy_dev
  azurecr_name          = local.docker_registry_italy_name_dev

  azurecr_subscription_name = var.dev_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
}

# 🟨 UAT service connection for azure container registry in italy north
resource "azuredevops_serviceendpoint_azurecr" "aks_cr_itn_uat" {
  depends_on = [azuredevops_project.project]

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_italy_rg_name_uat

  service_endpoint_name = local.srv_endpoint_name_docker_registry_italy_uat
  azurecr_name          = local.docker_registry_italy_name_uat

  azurecr_subscription_name = var.uat_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
}

# 🛑 PROD service connection for azure container registry in italy north
resource "azuredevops_serviceendpoint_azurecr" "aks_cr_itn_prod" {
  depends_on = [azuredevops_project.project]

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_italy_rg_name_prod

  service_endpoint_name = local.srv_endpoint_name_docker_registry_italy_prod
  azurecr_name          = local.docker_registry_italy_name_prod

  azurecr_subscription_name = var.prod_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
}
