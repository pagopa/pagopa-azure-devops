module "portalpa" {
  source = "../modules/github_application_pipeline"

  providers = {
    azurerm.dev  = azurerm.dev
    azurerm.uat  = azurerm.uat
    azurerm.prod = azurerm.prod
  }

  project_id                     = data.azuredevops_project.project.id
  github_service_connection_name = local.centralhub_github_connection_name
  github_token_secret_name       = local.centralhub_github_token_secret_name
  bootstrap_envs                 = local.centralhub_bootstrap_envs
  environment_secrets            = local.centralhub_environment_secrets
  append_env_suffix              = false
  base_variables                 = local.centralhub_base_variables
  applications                   = local.centralhub_applications
}
