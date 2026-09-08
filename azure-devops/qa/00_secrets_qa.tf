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
    azurerm = azurerm.dev
  }

  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  resource_group = local.dev_kv_domain_resource_group
  key_vault_name = local.dev_kv_domain_name

  secrets = [
    "pagopa-d-itn-dev-aks-azure-devops-sa-token",
    "pagopa-d-itn-dev-aks-azure-devops-sa-cacrt",
    "pagopa-d-itn-dev-aks-apiserver-url",
    "azure-devops-qa-github-token"
  ]
}

moved {
  from = module.qa_uat_secrets
  to   = module.uat_secrets
}

module "qa_dev_secrets" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  for_each = { for p in local.deploy_pipelines : p.name => p if contains(p.envs, "d") && try(p.kv_name, "") != "" }

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = format(each.value.rg_name, "d")
  key_vault_name = format(each.value.kv_name, "d")

  secrets = each.value.secrets
}


# module "qa_uat_secrets" {
#   source = "./.terraform/modules/__v3__/key_vault_secrets_query"
#
#   for_each = { for p in local.deploy_pipelines : p.name => p if contains(p.envs, "u") && try(p.kv_name, "") != "" }
#
#   providers = {
#     azurerm = azurerm.uat
#   }
#
#   resource_group = format(each.value.rg_name, "u")
#   key_vault_name = format(each.value.kv_name, "u")
#
#   secrets = each.value.secrets
# }

module "qa_prod_secrets" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  for_each = { for p in local.deploy_pipelines : p.name => p if contains(p.envs, "p") && try(p.kv_name, "") != "" }

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = format(each.value.rg_name, "p")
  key_vault_name = format(each.value.kv_name, "p")

  secrets = each.value.secrets
}
