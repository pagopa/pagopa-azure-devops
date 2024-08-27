#
# 🇪🇺 WEU
#

# 🟢 DEV service connection for azure container registry
resource "azuredevops_serviceendpoint_azurecr" "acr_docker_registry_dev_legacy_backup" {
  depends_on = [azuredevops_project.project]

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_rg_name_dev

  service_endpoint_name = "${local.srv_endpoint_name_docker_registry_dev}_legacy_backup"
  azurecr_name          = local.docker_registry_name_dev

  azurecr_subscription_name = var.dev_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id

  description = "Managed by terraform - Created on ${formatdate("YYYY-MM-DD", timestamp())}"
}

# 🟨 UAT service connection for azure container registry
resource "azuredevops_serviceendpoint_azurecr" "acr_docker_registry_uat_legacy_backup" {
  depends_on = [azuredevops_project.project]

  service_endpoint_name = "${local.srv_endpoint_name_docker_registry_uat}_legacy_backup"
  azurecr_name          = local.docker_registry_name_uat

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_rg_name_uat

  azurecr_subscription_name = var.uat_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id

  description = "Managed by terraform - Created on ${formatdate("YYYY-MM-DD", timestamp())}"
}

# 🛑 PROD service connection for azure container registry
resource "azuredevops_serviceendpoint_azurecr" "acr_docker_registry_prod_legacy_backup" {
  depends_on = [azuredevops_project.project]

  service_endpoint_name = "${local.srv_endpoint_name_docker_registry_prod}_legacy_backup"
  azurecr_name          = local.docker_registry_name_prod

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_rg_name_prod

  azurecr_subscription_name = var.prod_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id

  description = "Managed by terraform - Created on ${formatdate("YYYY-MM-DD", timestamp())}"
}

#
# 🇮🇹 Italy
#

# 🟢 DEV service connection for AKS container registry in italy north
resource "azuredevops_serviceendpoint_azurecr" "aks_cr_itn_dev_legacy_backup" {
  depends_on = [azuredevops_project.project]

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_italy_rg_name_dev

  service_endpoint_name = "${local.srv_endpoint_name_docker_registry_italy_dev}_legacy_backup"
  azurecr_name          = local.docker_registry_italy_name_dev

  azurecr_subscription_name = var.dev_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id

  description = "Managed by terraform - Created on ${formatdate("YYYY-MM-DD", timestamp())}"
}

# 🟨 UAT service connection for azure container registry in italy north
resource "azuredevops_serviceendpoint_azurecr" "aks_cr_itn_uat_legacy_backup" {
  depends_on = [azuredevops_project.project]

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_italy_rg_name_uat

  service_endpoint_name = "${local.srv_endpoint_name_docker_registry_italy_uat}_legacy_backup"
  azurecr_name          = local.docker_registry_italy_name_uat

  azurecr_subscription_name = var.uat_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id

  description = "Managed by terraform - Created on ${formatdate("YYYY-MM-DD", timestamp())}"
}

# 🛑 PROD service connection for azure container registry in italy north
resource "azuredevops_serviceendpoint_azurecr" "aks_cr_itn_prod_legacy_backup" {
  depends_on = [azuredevops_project.project]

  project_id     = azuredevops_project.project.id
  resource_group = local.docker_registry_italy_rg_name_prod

  service_endpoint_name = "${local.srv_endpoint_name_docker_registry_italy_prod}_legacy_backup"
  azurecr_name          = local.docker_registry_italy_name_prod

  azurecr_subscription_name = var.prod_subscription_name
  azurecr_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurecr_subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id

  description = "Managed by terraform - Created on ${formatdate("YYYY-MM-DD", timestamp())}"
}
