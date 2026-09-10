#
# Application domain Key Vaults — per-env secrets consumed by the pipelines.
# One module instance per pipeline that declares a `kv_name`, resolved per env.
# The secret names must exist in each KV (see each pipeline `secrets`).
#

# Domain-level QA GitHub PAT.
module "dev_secrets" {

  providers = {
    azurerm = azurerm.dev
  }

  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  resource_group = local.dev_kv_domain_resource_group
  key_vault_name = local.dev_kv_domain_name

  secrets = [
    "pagopa-d-itn-dev-aks-azure-devops-sa-token",
    "pagopa-d-itn-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-itn-dev-aks-apiserver-url"
  ]
}

module "uat_secrets" {

  providers = {
    azurerm = azurerm.uat
  }

  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  resource_group = local.uat_kv_domain_resource_group
  key_vault_name = local.uat_kv_domain_name

  secrets = [
    "pagopa-u-itn-uat-aks-azure-devops-sa-token",
    "pagopa-u-itn-uat-aks-azure-devops-sa-cacrt",
    "pagopa-u-itn-uat-aks-apiserver-url",
    "azure-devops-qa-github-token"
  ]
}

module "prod_secrets" {

  providers = {
    azurerm = azurerm.prod
  }

  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  resource_group = local.prod_kv_domain_resource_group
  key_vault_name = local.prod_kv_domain_name

  secrets = [
    "pagopa-p-itn-prod-aks-azure-devops-sa-token",
    "pagopa-p-itn-prod-aks-azure-devops-sa-cacrt",
    "pagopa-p-itn-prod-aks-apiserver-url",
  ]
}


moved {
  from = module.qa_prod_secrets
  to   = module.prod_secrets
}
