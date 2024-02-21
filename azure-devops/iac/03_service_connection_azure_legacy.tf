#
# ⛩ Service connections AZURE
#

# DEV service connection
resource "azuredevops_serviceendpoint_azurerm" "DEV-PAGOPA-IAC-LEGACY" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "DEV-PAGOPA-IAC-LEGACY-SERVICE-CONN"
  description               = "DEV-PAGOPA-IAC-LEGACY Service connection"
  azurerm_subscription_name = "DEV-PAGOPA-IAC-LEGACY"
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
}

# UAT service connection
resource "azuredevops_serviceendpoint_azurerm" "UAT-PAGOPA-IAC-LEGACY" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "UAT-PAGOPA-IAC-LEGACY-SERVICE-CONN"
  description               = "UAT-PAGOPA-IAC-LEGACY Service connection"
  azurerm_subscription_name = "UAT-PAGOPA-IAC-LEGACY"
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
}

# PROD service connection
resource "azuredevops_serviceendpoint_azurerm" "PROD-PAGOPA-IAC-LEGACY" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "PROD-PAGOPA-IAC-LEGACY-SERVICE-CONN"
  description               = "PROD-PAGOPA-IAC-LEGACY Service connection"
  azurerm_subscription_name = "PROD-PAGOPA-IAC-LEGACY"
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
}

#
# PLAN
#

#
# DEV
#
module "DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.dev
  }

  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_plan?ref=v7.0.0"

  name_suffix                 = "PAGOPA-IAC-LEGACY-dev"
  iac_aad_group_name          = "azure-devops-iac-service-connection"
  password_time_rotation_days = 365
  renew_token                 = "v2"

  project_id      = azuredevops_project.project.id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  subscription_id = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id

  credential_key_vault_name           = local.dev_key_vault_name
  credential_key_vault_resource_group = local.dev_key_vault_resource_group
}

resource "azurerm_role_assignment" "plan_legacy_iac_dev" {

  scope                = data.azurerm_subscriptions.dev.subscriptions[0].id
  role_definition_name = "PagoPA Platform Dev IaC Reader"
  principal_id         = module.DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_principal_object_id
}

#
# UAT
#
module "UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.uat
  }

  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_plan?ref=v7.0.0"

  name_suffix                 = "PAGOPA-IAC-LEGACY-uat"
  iac_aad_group_name          = "azure-devops-iac-service-connection"
  password_time_rotation_days = 365
  renew_token                 = "v2"

  project_id      = azuredevops_project.project.id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  subscription_id = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id

  credential_key_vault_name           = local.uat_key_vault_name
  credential_key_vault_resource_group = local.uat_key_vault_resource_group
}

resource "azurerm_role_assignment" "plan_legacy_iac_uat" {

  scope                = data.azurerm_subscriptions.uat.subscriptions[0].id
  role_definition_name = "PagoPA Platform Uat IaC Reader"
  principal_id         = module.UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_principal_object_id
}

#
# PROD
#
module "PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.prod
  }

  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_plan?ref=v7.0.0"

  name_suffix                 = "PAGOPA-IAC-LEGACY-prod"
  iac_aad_group_name          = "azure-devops-iac-service-connection"
  password_time_rotation_days = 365
  renew_token                 = "v2"

  project_id      = azuredevops_project.project.id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  subscription_id = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id

  credential_key_vault_name           = local.prod_key_vault_name
  credential_key_vault_resource_group = local.prod_key_vault_resource_group
}

resource "azurerm_role_assignment" "plan_legacy_iac_prod" {

  scope                = data.azurerm_subscriptions.prod.subscriptions[0].id
  role_definition_name = "PagoPA Platform Prod IaC Reader"
  principal_id         = module.PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_principal_object_id
}
