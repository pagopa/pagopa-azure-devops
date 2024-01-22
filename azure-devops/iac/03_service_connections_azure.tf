#
# ⛩ Service connections
#

module "DEV-AZURERM-IAC-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v5.0.0"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name = "AZDO-DEV-PAGOPA-IAC"

  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  subscription_name = var.dev_subscription_name

  location            = var.location
  resource_group_name = local.dev_identity_rg_name
}

# 🟢 DEV service connection
resource "azuredevops_serviceendpoint_azurerm" "DEV-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "${var.dev_subscription_name}-SERVICE-CONN"
  description               = "${var.dev_subscription_name} Service connection"
  azurerm_subscription_name = var.dev_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
}

#
# UAT
#

module "UAT-AZURERM-IAC-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v5.0.0"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name = "AZDO-UAT-PAGOPA-IAC"

  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name = var.uat_subscription_name

  location            = var.location
  resource_group_name = local.uat_identity_rg_name
}

# 🟨 UAT service connection
resource "azuredevops_serviceendpoint_azurerm" "UAT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "${var.uat_subscription_name}-SERVICE-CONN"
  description               = "${var.uat_subscription_name} Service connection"
  azurerm_subscription_name = var.uat_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
}

#
# PROD
#
module "PROD-AZURERM-IAC-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v5.0.0"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  name = "AZDO-PROD-PAGOPA-IAC"

  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name = var.prod_subscription_name

  location            = var.location
  resource_group_name = local.prod_identity_rg_name
}

# 🛑 PROD service connection
resource "azuredevops_serviceendpoint_azurerm" "PROD-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]

  project_id                = azuredevops_project.project.id
  service_endpoint_name     = "${var.prod_subscription_name}-SERVICE-CONN"
  description               = "${var.prod_subscription_name} Service connection"
  azurerm_subscription_name = var.prod_subscription_name
  azurerm_spn_tenantid      = module.secrets.values["TENANTID"].value
  azurerm_subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
}
