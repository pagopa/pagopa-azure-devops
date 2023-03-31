#
# DEV
#
module "DEV-APICONFIG-TLS-CERT-SERVICE-CONN" {

  providers = {
    azurerm = azurerm.dev
  }

  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.6.5"

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-d-${local.domain}-tls-cert"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_name = var.dev_subscription_name
  subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
  #tfsec:ignore:GEN003
  renew_token = local.tlscert_renew_token

  credential_subcription              = var.dev_subscription_name
  credential_key_vault_name           = local.dev_apiconfig_key_vault_name
  credential_key_vault_resource_group = local.dev_apiconfig_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-APICONFIG-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.dev
  key_vault_id = data.azurerm_key_vault.domain_kv_dev.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.DEV-APICONFIG-TLS-CERT-SERVICE-CONN.service_principal_object_id

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
  key_vault_name    = local.dev_apiconfig_key_vault_name
  subscription_name = var.dev_subscription_name
}

#
# UAT
#
module "UAT-APICONFIG-TLS-CERT-SERVICE-CONN" {
  providers = {
    azurerm = azurerm.uat
  }

  depends_on = [data.azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.6.5"

  project_id        = data.azuredevops_project.project.id
  name              = "${local.prefix}-u-${local.domain}-tls-cert"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_name = var.uat_subscription_name
  subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
  #tfsec:ignore:GEN003
  renew_token = local.tlscert_renew_token

  credential_subcription              = var.uat_subscription_name
  credential_key_vault_name           = local.uat_apiconfig_key_vault_name
  credential_key_vault_resource_group = local.uat_apiconfig_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-APICONFIG-TLS-CERT-SERVICE-CONN_kv_access_policy" {
  provider     = azurerm.uat
  key_vault_id = data.azurerm_key_vault.domain_kv_uat.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.UAT-APICONFIG-TLS-CERT-SERVICE-CONN.service_principal_object_id

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
  key_vault_name    = local.uat_apiconfig_key_vault_name
  subscription_name = var.uat_subscription_name
}

# #
# # PROD
# #
# module "PROD-APICONFIG-TLS-CERT-SERVICE-CONN" {

#   providers = {
#     azurerm = azurerm.prod
#   }

#   depends_on = [data.azuredevops_project.project]
#   source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.6.5"

#   project_id        = data.azuredevops_project.project.id
#   name              = "${local.prefix}-p-${local.domain}-tls-cert"
#   tenant_id         = module.secrets.values["TENANTID"].value
#   subscription_name = var.prod_subscription_name
#   subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
#   #tfsec:ignore:GEN003
#   renew_token = local.tlscert_renew_token

#   credential_subcription              = var.prod_subscription_name
#   credential_key_vault_name           = local.prod_apiconfig_key_vault_name
#   credential_key_vault_resource_group = local.prod_apiconfig_key_vault_resource_group
# }

# resource "azurerm_key_vault_access_policy" "PROD-APICONFIG-TLS-CERT-SERVICE-CONN_kv_access_policy" {
#   provider     = azurerm.prod
#   key_vault_id = data.azurerm_key_vault.domain_kv_prod.id
#   tenant_id    = module.secrets.values["TENANTID"].value
#   object_id    = module.PROD-APICONFIG-TLS-CERT-SERVICE-CONN.service_principal_object_id

#   certificate_permissions = ["Get", "Import"]
# }

# # create let's encrypt credential used to create SSL certificates
# module "letsencrypt_prod" {
#   source = "git::https://github.com/pagopa/azurerm.git//letsencrypt_credential?ref=v2.18.0"

#   providers = {
#     azurerm = azurerm.prod
#   }
#   prefix            = local.prefix
#   env               = "p"
#   key_vault_name    = local.prod_apiconfig_key_vault_name
#   subscription_name = var.prod_subscription_name
# }
