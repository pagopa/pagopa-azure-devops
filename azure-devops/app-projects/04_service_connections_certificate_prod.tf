#
# ⛩ Service connection 2 🔐 KV@PROD 🛑
#
#tfsec:ignore:GEN003
module "PROD-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-p-tls-cert"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
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

resource "azurerm_key_vault_access_policy" "PROD-TLS-CERT-SERVICE-CONN_kv_prod" {
  provider     = azurerm.prod
  key_vault_id = data.azurerm_key_vault.kv_prod.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.PROD-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}
