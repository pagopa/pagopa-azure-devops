#
# DEV
#
module "DEV-PAYOPT-TLS-CERT-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.dev
  }

  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v9.2.1"


  project_id          = data.azuredevops_project.project.id
  name                = "${local.prefix}-${local.domain}-d-tls-cert-azdo"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  subscription_name   = var.dev_subscription_name
  subscription_id     = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  resource_group_name = local.dev_identity_rg_name
  location            = local.location_westeurope

}

resource "azurerm_key_vault_access_policy" "DEV-PAYOPT-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.dev
  key_vault_id = data.azurerm_key_vault.domain_kv_dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.DEV-PAYOPT-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

##
## UAT
##
module "UAT-PAYOPT-TLS-CERT-SERVICE-CONN" {
  providers = {
    azurerm = azurerm.uat
  }

  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v9.2.1"

  project_id          = data.azuredevops_project.project.id
  name                = "${local.prefix}-${local.domain}-u-tls-cert-azdo"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  subscription_name   = var.uat_subscription_name
  subscription_id     = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  location            = local.location_westeurope
  resource_group_name = local.uat_identity_rg_name
}

resource "azurerm_key_vault_access_policy" "UAT-PAYOPT-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.uat
  key_vault_id = data.azurerm_key_vault.domain_kv_uat.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.UAT-PAYOPT-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# PROD
#
module "PROD-PAYOPT-TLS-CERT-SERVICE-CONN" {
  providers = {
    azurerm = azurerm.prod
  }

  depends_on = [data.azuredevops_project.project]
 source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v9.2.1"

  project_id          = data.azuredevops_project.project.id
  name                = "${local.prefix}-${local.domain}-p-tls-cert-azdo"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  subscription_name   = var.prod_subscription_name
  subscription_id     = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  location            = local.location_westeurope
  resource_group_name = local.prod_identity_rg_name
}

resource "azurerm_key_vault_access_policy" "PROD-PAYOPT-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.prod
  key_vault_id = data.azurerm_key_vault.domain_kv_prod.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.PROD-PAYOPT-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}
