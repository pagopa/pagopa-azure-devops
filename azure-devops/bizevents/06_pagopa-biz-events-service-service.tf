variable "pagopa-biz-events-service-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-biz-events-service"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      sonarcloud = {
        # TODO azure devops terraform provider does not support SonarCloud service endpoint
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-biz-events-service"
        project_name       = "pagopa-biz-events-service"
      }
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
  pagopa-biz-events-service-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-biz-events-service-service.repository.branch_name
  }
  # global secrets
  pagopa-biz-events-service-service-variables_secret = {

  }
  # performance vars
  pagopa-biz-events-service-variables_performance_test = {
  }
  # performance secrets
  pagopa-biz-events-service-variables_secret_performance_test = {
    DEV_COSMOS_DB_PRIMARY_KEY = module.bizevents_dev_secrets.values["cosmos-d-biz-key"].value
    UAT_COSMOS_DB_PRIMARY_KEY = module.bizevents_uat_secrets.values["cosmos-u-biz-key"].value
  }
}

module "pagopa-biz-events-service-service_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-biz-events-service-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-biz-events-service-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-biz-events-service-service"
  pipeline_name                = var.pagopa-biz-events-service-service.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-biz-events-service-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-biz-events-service-service-variables,
    local.pagopa-biz-events-service-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-biz-events-service-service-variables_secret,
    local.pagopa-biz-events-service-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
