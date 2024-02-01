#
# ⛩ Service connections AZURE
#

# DEV service connection
resource "azuredevops_serviceendpoint_azurerm" "DEV-PAGOPA-LEGACY" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "DEV-PAGOPA-LEGACY-SERVICE-CONN"
  description               = "DEV-PAGOPA-LEGACY Service connection"
  azurerm_subscription_name = "DEV-PAGOPA-LEGACY"
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
}

# UAT service connection
resource "azuredevops_serviceendpoint_azurerm" "UAT-PAGOPA-LEGACY" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "UAT-PAGOPA-LEGACY-SERVICE-CONN"
  description               = "UAT-PAGOPA-LEGACY Service connection"
  azurerm_subscription_name = "UAT-PAGOPA-LEGACY"
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
}

# PROD service connection
resource "azuredevops_serviceendpoint_azurerm" "PROD-PAGOPA-LEGACY" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "PROD-PAGOPA-LEGACY-SERVICE-CONN"
  description               = "PROD-PAGOPA-LEGACY Service connection"
  azurerm_subscription_name = "PROD-PAGOPA-LEGACY"
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
}

#
# DEV
#
module "DEV-PAGOPA-LEGACY-PLAN-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.dev
  }

  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_plan?ref=v5.5.0"

  name_suffix                 = "pagopa-legacy-dev"
  iac_aad_group_name          = "azure-devops-iac-service-connection"
  password_time_rotation_days = 365
  renew_token                 = "v2"


  project_id      = azuredevops_project.project.id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  subscription_id = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id

  credential_key_vault_name           = local.dev_key_vault_name
  credential_key_vault_resource_group = local.dev_key_vault_resource_group
}

#
# UAT
#
module "UAT-PAGOPA-LEGACY-PLAN-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.uat
  }

  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_plan?ref=v5.5.0"

  name_suffix                 = "pagopa-legacy-uat"
  iac_aad_group_name          = "azure-devops-iac-service-connection"
  password_time_rotation_days = 365
  renew_token                 = "v2"


  project_id      = azuredevops_project.project.id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  subscription_id = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id

  credential_key_vault_name           = local.uat_key_vault_name
  credential_key_vault_resource_group = local.uat_key_vault_resource_group
}

#
# PROD
#
module "PROD-PAGOPA-LEGACY-PLAN-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.prod
  }

  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_plan?ref=v5.5.0"

  name_suffix                 = "pagopa-legacy-prod"
  iac_aad_group_name          = "azure-devops-iac-service-connection"
  password_time_rotation_days = 365
  renew_token                 = "v2"


  project_id      = azuredevops_project.project.id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  subscription_id = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id

  credential_key_vault_name           = local.prod_key_vault_name
  credential_key_vault_resource_group = local.prod_key_vault_resource_group
}
