#
# ⛩ Service connection 2 🔐 KV@DEV 🟢
#
#tfsec:ignore:GEN003
module "DEV-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-d-tls-cert"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
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

resource "azurerm_key_vault_access_policy" "DEV-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_dev.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.DEV-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}
