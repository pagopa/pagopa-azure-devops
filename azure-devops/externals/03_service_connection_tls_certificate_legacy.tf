#
# ⛩ Service connection 2 🔐 KV@DEV 🟢
#
#tfsec:ignore:GEN003
module "DEV-TLS-CERT-EXTERNALS-SERVICE-CONN" {
  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v5.5.0"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = data.azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-d-tls-cert-externals-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  subscription_name = var.dev_subscription_name

  credential_subcription              = var.dev_subscription_name
  credential_key_vault_name           = local.dev_key_vault_name
  credential_key_vault_resource_group = local.dev_key_vault_resource_group
}

data "azurerm_key_vault" "kv_dev" {
  provider            = azurerm.dev
  name                = local.dev_key_vault_name
  resource_group_name = local.dev_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-TLS-CERT-EXTERNALS-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.DEV-TLS-CERT-EXTERNALS-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV@UAT 🟨
#
#tfsec:ignore:GEN003
module "UAT-TLS-CERT-EXTERNALS-SERVICE-CONN" {
  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v5.5.0"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = data.azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-u-tls-cert-externals-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  subscription_name = var.uat_subscription_name

  credential_subcription              = var.uat_subscription_name
  credential_key_vault_name           = local.uat_key_vault_name
  credential_key_vault_resource_group = local.uat_key_vault_resource_group
}

data "azurerm_key_vault" "kv_uat" {
  provider            = azurerm.uat
  name                = local.uat_key_vault_name
  resource_group_name = local.uat_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-TLS-CERT-EXTERNALS-SERVICE-CONN_kv_uat" {
  provider     = azurerm.uat
  key_vault_id = data.azurerm_key_vault.kv_uat.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.UAT-TLS-CERT-EXTERNALS-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV@PROD 🛑
#
#tfsec:ignore:GEN003
module "PROD-TLS-CERT-EXTERNALS-SERVICE-CONN" {
  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v5.5.0"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = data.azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-p-tls-cert-externals-kv-policy"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  subscription_name = var.prod_subscription_name

  credential_subcription              = var.prod_subscription_name
  credential_key_vault_name           = local.prod_key_vault_name
  credential_key_vault_resource_group = local.prod_key_vault_resource_group
}

data "azurerm_key_vault" "kv_prod" {
  provider            = azurerm.prod
  name                = local.prod_key_vault_name
  resource_group_name = local.prod_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-TLS-CERT-EXTERNALS-SERVICE-CONN_kv_prod" {
  provider     = azurerm.prod
  key_vault_id = data.azurerm_key_vault.kv_prod.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.PROD-TLS-CERT-EXTERNALS-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}
