#
# QA domain Key Vaults — FE OAuth/NextAuth secrets consumed by the pipeline.
# ⚠️ TODO confirm the secret names actually stored in each KV.
#
module "qa_dev_secrets" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_qa_key_vault_resource_group
  key_vault_name = local.dev_qa_key_vault_name

  secrets = [
    "nextauth-secret",
    "google-client-id",
    "google-client-secret",
  ]
}

module "qa_uat_secrets" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_qa_key_vault_resource_group
  key_vault_name = local.uat_qa_key_vault_name

  secrets = [
    "nextauth-secret",
    "google-client-id",
    "google-client-secret",
  ]
}

module "qa_prod_secrets" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_qa_key_vault_resource_group
  key_vault_name = local.prod_qa_key_vault_name

  secrets = [
    "nextauth-secret",
    "google-client-id",
    "google-client-secret",
  ]
}
