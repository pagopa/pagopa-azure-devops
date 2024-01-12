variable "pagopa-debt-position" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-debt-position"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_deploy = true
      performance_test = {
        enabled               = true
        name                  = "performance-test-gpd-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-debt-position-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-debt-position.repository.branch_name
  }
  # global secrets
  pagopa-debt-position-variables_secret = {
  }

  # performance test vars
  pagopa-debt-position-variables_performance_test = {
  }
  # performance test secrets
  pagopa-debt-position-variables_secret_performance_test = {
    DEV_API_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-api-subscription-key"].value
    UAT_API_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-api-subscription-key"].value
  }
}

module "pagopa-debt-position_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.1.5"
  count  = var.pagopa-debt-position.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-debt-position.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-gpd-core"
  pipeline_name                = var.pagopa-debt-position.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-debt-position.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-debt-position-variables,
    local.pagopa-debt-position-variables_performance_test
  )

  variables_secret = merge(
    local.pagopa-debt-position-variables_secret,
    local.pagopa-debt-position-variables_secret_performance_test
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}
