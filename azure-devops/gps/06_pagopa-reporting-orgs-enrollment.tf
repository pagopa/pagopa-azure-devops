variable "pagopa-reporting-orgs-enrollment" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-reporting-orgs-enrollment"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      performance_test = {
        enabled               = true
        name                  = "performance-test-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
      sonarcloud = {
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-reporting-orgs-enrollment"
        project_name       = "pagopa-reporting-orgs-enrollment"
      }
    }
  }
}

locals {
  # global vars
  pagopa-reporting-orgs-enrollment-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-reporting-orgs-enrollment.repository.branch_name
  }
  # global secrets
  pagopa-reporting-orgs-enrollment-variables_secret = {
  }

  # performance secrets
  pagopa-reporting-orgs-enrollment_performance_test = {
  }
  pagopa-reporting-orgs-enrollment-variables_secret_performance_test = {
    DEV_API_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-d-reporting-enrollment-subscription-key"].value
    UAT_API_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-u-reporting-enrollment-subscription-key"].value
  }
}

module "pagopa-reporting-orgs-enrollment_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v2.6.3"
  count  = var.pagopa-reporting-orgs-enrollment.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-reporting-orgs-enrollment.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  path                         = "${local.domain}\\pagopa-reporting-orgs-enrollment"
  pipeline_name                = var.pagopa-reporting-orgs-enrollment.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-reporting-orgs-enrollment.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-reporting-orgs-enrollment-variables,
    local.pagopa-reporting-orgs-enrollment_performance_test,
  )

  variables_secret = merge(
    local.pagopa-reporting-orgs-enrollment-variables_secret,
    local.pagopa-reporting-orgs-enrollment-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}
