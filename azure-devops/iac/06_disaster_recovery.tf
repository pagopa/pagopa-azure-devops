module "disaster_recovery" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.1.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.disaster_recovery.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = "disaster-recovery"
  pipeline_name                = "disaster-recovery"
  pipeline_yml_filename        = "disaster-recovery.yml"

  ci_trigger_use_yaml = false

  variables = {

    TF_POOL_NAME_DEV  = "pagopa-dev-linux-infra",
    TF_POOL_NAME_UAT  = "pagopa-uat-linux-infra",
    TF_POOL_NAME_PROD = "pagopa-prod-linux-infra",
    #APPLY
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV  = module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT  = module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD = module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
  }

  variables_secret = {}

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
  ]

}
