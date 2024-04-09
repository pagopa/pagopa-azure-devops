module "disaster_recovery" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.1.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.disaster_recovery.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = "disaster-recovery"
  pipeline_name                = "postgres-failover"
  pipeline_yml_filename        = "postgres-failover.yml"

  ci_trigger_use_yaml = false

  variables = {}

  variables_secret = {}

  service_connection_ids_authorization = [
    module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
  ]

}
