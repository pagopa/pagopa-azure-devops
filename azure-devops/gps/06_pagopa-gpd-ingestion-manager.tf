variable "pagopa-gpd-ingestion-manager" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-gpd-ingestion-manager"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_deploy = true
      performance_test = {
        enabled               = true
        name                  = "performance-test-gpd-ingestion-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-gpd-ingestion-manager-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-gpd-ingestion-manager.repository.branch_name
  }
  # global secrets
  pagopa-gpd-ingestion-manager-variables_secret = {
  }

  # performance test vars
  pagopa-gpd-ingestion-manager-variables_performance_test = {
  }
  # performance test secrets
  pagopa-gpd-ingestion-manager-variables_secret_performance_test = {
    DEV_PG_GPD_PASSWORD = module.gps_dev_secrets.values["db-apd-user-password"].value
    DEV_PG_GPD_USER = module.gps_dev_secrets.values["db-apd-user-name"].value
    DEV_INGESTION_EVENTHUB_CONN_STRING = module.gps_dev_secrets.values["cdc-gpd-test-connection-string"].value
    UAT_PG_GPD_PASSWORD = module.gps_uat_secrets.values["db-apd-user-password"].value
    UAT_PG_GPD_USER = module.gps_dev_secrets.values["db-apd-user-name"].value
    UAT_INGESTION_EVENTHUB_CONN_STRING = module.gps_uat_secrets.values["cdc-gpd-test-connection-string"].value
  }
}

module "pagopa-gpd-ingestion-manager_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v9.0.0"
  count  = var.pagopa-gpd-ingestion-manager.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-ingestion-manager.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-gpd-ingestion-manager"
  pipeline_name                = var.pagopa-gpd-ingestion-manager.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-gpd-ingestion-manager.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-gpd-ingestion-manager-variables,
    local.pagopa-gpd-ingestion-manager-variables_performance_test
  )

  variables_secret = merge(
    local.pagopa-gpd-ingestion-manager-variables_secret,
    local.pagopa-gpd-ingestion-manager-variables_secret_performance_test
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
