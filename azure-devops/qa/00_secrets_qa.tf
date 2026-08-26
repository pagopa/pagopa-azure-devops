#
# Application domain Key Vaults — per-env secrets consumed by the pipelines.
# One module instance per pipeline that declares a `kv_name`, resolved per env.
# The secret names must exist in each KV (see each pipeline `secrets`).
#

# Domain-level QA GitHub PAT.
module "qa_github_token" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_qa_github_kv_rg
  key_vault_name = local.uat_qa_github_kv_name

  secrets = ["azure-devops-qa-github-token"]
}
