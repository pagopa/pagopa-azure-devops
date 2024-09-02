variable "pagopa-wisp-soap-converter-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-wisp-converter"
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
  pagopa-wisp-soap-converter-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-wisp-soap-converter-service.repository.branch_name
  }
  # global secrets
  pagopa-wisp-soap-converter-service-variables_secret = {

  }

  # performance vars
  pagopa-wisp-soap-converter-service-variables_performance_test = {

  }
  # performance secrets
  pagopa-wisp-soap-converter-service-variables_secret_performance_test = {
    DEV_NODO_PA_SUBSCRIPTION_KEY = module.nodo_dev_secrets.values["integration-test-nodo-subscription-key"].value
    DEV_STATION_PASSWORD         = module.nodo_dev_secrets.values["station-pwd-perf-test"].value
    DEV_CHANNEL_PASSWORD         = module.nodo_dev_secrets.values["channel-pwd-perf-test"].value
    #####
    UAT_NODO_PA_SUBSCRIPTION_KEY = module.nodo_uat_secrets.values["integration-test-nodo-subscription-key"].value
    UAT_STATION_PASSWORD         = module.nodo_uat_secrets.values["station-pwd-perf-test"].value
    UAT_CHANNEL_PASSWORD         = module.nodo_uat_secrets.values["channel-pwd-perf-test"].value
  }

}

module "pagopa-wisp-soap-converter-service_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-wisp-soap-converter-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-wisp-soap-converter-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-wisp-soap-converter-service"
  pipeline_name                = var.pagopa-wisp-soap-converter-service.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-wisp-soap-converter-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-wisp-soap-converter-service-variables,
    local.pagopa-wisp-soap-converter-service-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-wisp-soap-converter-service-variables_secret,
    local.pagopa-wisp-soap-converter-service-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]

}
