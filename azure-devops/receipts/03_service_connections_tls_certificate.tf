#
# DEV
#
module "DEV-RECEIPTS-TLS-CERT-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.dev
  }

  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v4.1.5"

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-d-${local.domain}-tls-cert"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_name = var.dev_subscription_name
  subscription_id   = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
  #tfsec:ignore:GEN003
  renew_token = local.tlscert_renew_token

  credential_subcription              = var.dev_subscription_name
  credential_key_vault_name           = local.dev_receipts_key_vault_name
  credential_key_vault_resource_group = local.dev_receipts_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-RECEIPTS-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.dev
  key_vault_id = data.azurerm_key_vault.domain_kv_dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.DEV-RECEIPTS-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

# create let's encrypt credential used to create SSL certificates
module "letsencrypt_dev" {
  source = "git::https://github.com/pagopa/azurerm.git//letsencrypt_credential?ref=v3.12.0"

  providers = {
    azurerm = azurerm.dev
  }
  prefix            = local.prefix
  env               = "d"
  key_vault_name    = local.dev_receipts_key_vault_name
  subscription_name = var.dev_subscription_name
}

#
# UAT
#
module "UAT-RECEIPTS-TLS-CERT-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.uat
  }

  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v4.1.5"

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-u-${local.domain}-tls-cert"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_name = var.uat_subscription_name
  subscription_id   = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
  #tfsec:ignore:GEN003
  renew_token = local.tlscert_renew_token

  credential_subcription              = var.uat_subscription_name
  credential_key_vault_name           = local.uat_receipts_key_vault_name
  credential_key_vault_resource_group = local.uat_receipts_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-RECEIPTS-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.uat
  key_vault_id = data.azurerm_key_vault.domain_kv_uat.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.UAT-RECEIPTS-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

# create let's encrypt credential used to create SSL certificates
module "letsencrypt_uat" {
  source = "git::https://github.com/pagopa/azurerm.git//letsencrypt_credential?ref=v2.18.0"

  providers = {
    azurerm = azurerm.uat
  }
  prefix            = local.prefix
  env               = "u"
  key_vault_name    = local.uat_receipts_key_vault_name
  subscription_name = var.uat_subscription_name
}

#
# PROD
#
module "PROD-RECEIPTS-TLS-CERT-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.prod
  }

  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v4.1.5"

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-p-${local.domain}-tls-cert"
  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_name = var.prod_subscription_name
  subscription_id   = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
  #tfsec:ignore:GEN003
  renew_token = local.tlscert_renew_token

  credential_subcription              = var.prod_subscription_name
  credential_key_vault_name           = local.prod_receipts_key_vault_name
  credential_key_vault_resource_group = local.prod_receipts_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-RECEIPTS-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.prod
  key_vault_id = data.azurerm_key_vault.domain_kv_prod.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.PROD-RECEIPTS-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

# create let's encrypt credential used to create SSL certificates
module "letsencrypt_prod" {
  source = "git::https://github.com/pagopa/azurerm.git//letsencrypt_credential?ref=v2.18.0"

  providers = {
    azurerm = azurerm.prod
  }
  prefix            = local.prefix
  env               = "p"
  key_vault_name    = local.prod_receipts_key_vault_name
  subscription_name = var.prod_subscription_name
}
