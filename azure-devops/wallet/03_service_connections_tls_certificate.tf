#
# DEV
#
module "DEV-WALLET-TLS-CERT-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.dev
  }

  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.1.5"

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-d-${local.domain}-tls-cert-azdo"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_name = var.dev_subscription_name
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id

  location            = var.location
  resource_group_name = local.dev_identity_rg_name
}

resource "azurerm_key_vault_access_policy" "DEV-WALLET-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.dev
  key_vault_id = data.azurerm_key_vault.domain_kv_dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.DEV-WALLET-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

# create let's encrypt credential used to create SSL certificates
module "letsencrypt_dev" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential?ref=v7.30.0"

  providers = {
    azurerm = azurerm.dev
  }
  prefix            = local.prefix
  env               = "d"
  key_vault_name    = local.dev_wallet_key_vault_name
  subscription_name = var.dev_subscription_name
}

#
# UAT
#
module "UAT-WALLET-TLS-CERT-SERVICE-CONN" {
  providers = {
    azurerm = azurerm.uat
  }

  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_federated?ref=v4.1.5"

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-u-${local.domain}-tls-cert-azdo"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_name = var.uat_subscription_name
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id

  location            = var.location
  resource_group_name = local.uat_identity_rg_name
}

resource "azurerm_key_vault_access_policy" "UAT-WALLET-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.uat
  key_vault_id = data.azurerm_key_vault.domain_kv_uat.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.UAT-WALLET-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

# create let's encrypt credential used to create SSL certificates
module "letsencrypt_uat" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//letsencrypt_credential?ref=v7.30.0"

  providers = {
    azurerm = azurerm.uat
  }
  prefix            = local.prefix
  env               = "u"
  key_vault_name    = local.uat_wallet_key_vault_name
  subscription_name = var.uat_subscription_name
}
