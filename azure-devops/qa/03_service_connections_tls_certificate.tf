#
# 🟢 DEV - TLS CERTIFICATE
#
module "dev_tls_cert_service_connection" {
  source = "./.terraform/modules/__azdo__/workflow_tls_cert_service_connection"


  providers = {
    azurerm = azurerm.dev
  }

  env_short       = "d"
  prefix          = local.prefix
  location        = var.location
  azdo_project_id = data.azuredevops_project.project.id

  identity_name                = "${local.prefix}-dev-${local.domain}-azdo-tls-cert"
  identity_resource_group_name = local.dev_identity_rg_name
  key_vault_id                 = data.azurerm_key_vault.dev_kv_domain.id
  key_vault_name               = local.dev_kv_domain_name

  tenant_id         = data.azurerm_client_config.current.tenant_id
  subscription_name = local.dev_subscription_name
  subscription_id   = local.dev_subscription_id
}
