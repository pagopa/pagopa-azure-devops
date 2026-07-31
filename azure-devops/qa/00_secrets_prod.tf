#
# PROD KEYVAULT
#
module "secrets" {
  source = "./.terraform/modules/__v3__/key_vault_secrets_query"

  resource_group = local.prod_key_vault_resource_group
  key_vault_name = local.prod_key_vault_azdo_name

  secrets = [
    "azure-devops-github-EMAIL",
    "azure-devops-github-USERNAME",
  ]
}
