variable "pagopa-gps-mbd-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-gps-mbd-service"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      performance_test = {
        enabled               = true
        name                  = "performance-test-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-gps-mbd-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-gps-mbd-service.repository.branch_name
  }
  # global secrets
  pagopa-gps-mbd-service-variables_secret = {
  }
  # performance vars
  pagopa-gps-mbd-service-variables_performance_test = {
  }
  # performance secrets
  pagopa-gps-mbd-service-variables_secret_performance_test = {
    DEV_API_SUBSCRIPTION_KEY = module.ebollo_dev_secrets.values["apikey-gps-mbd-integration-test"].value
    UAT_API_SUBSCRIPTION_KEY = module.ebollo_uat_secrets.values["apikey-gps-mbd-integration-test"].value
  }

}

module "pagopa-gps-mbd-service_performance_test" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_generic"

  count = var.pagopa-gps-mbd-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gps-mbd-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-gps-mbd-service"
  pipeline_name                = var.pagopa-gps-mbd-service.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-gps-mbd-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-gps-mbd-service-variables,
    local.pagopa-gps-mbd-service-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-gps-mbd-service-variables_secret,
    local.pagopa-gps-mbd-service-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
