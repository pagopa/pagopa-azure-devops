#
# Domain-level GitHub PAT for Central Hub pipelines.
# The PAT must include at least: repo + admin:repo_hook.
#
module "centralhub_github_token" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_centralhub_github_kv_rg
  key_vault_name = local.prod_centralhub_github_kv_name

  secrets = ["azure-devops-centralhub-github-token"]
}
