module "portalpa" {
  source = "../.modules/github_application_pipeline"
  providers = {
    azurerm = azurerm.prod
  }

  project_id                            = data.azuredevops_project.project.id
  github_service_connection_name        = local.centralhub_github_connection_name
  github_token_key_vault_name           = local.prod_centralhub_github_kv_name
  github_token_key_vault_resource_group = local.prod_centralhub_github_kv_rg
  github_token_secret_name              = "azure-devops-centralhub-github-token"
  base_variables                        = local.centralhub_base_variables
  applications                          = local.centralhub_applications
}
