#
# Look up the GitHub PAT TOKEN used by the TAS orchestrator from each environment KV.
#
module "qa_dev_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.dev
  }

  resource_group = local.dev_qa_key_vault_resource_group
  key_vault_name = local.dev_qa_key_vault_name

  secrets = [
    local.tas_integration_pat_secret_name,
  ]
}

module "qa_uat_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.uat
  }

  resource_group = local.uat_qa_key_vault_resource_group
  key_vault_name = local.uat_qa_key_vault_name

  secrets = [
    local.tas_integration_pat_secret_name,
  ]
}

module "qa_prod_secrets" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=v7.30.0"

  providers = {
    azurerm = azurerm.prod
  }

  resource_group = local.prod_qa_key_vault_resource_group
  key_vault_name = local.prod_qa_key_vault_name

  secrets = [
    local.tas_integration_pat_secret_name,
  ]
}
