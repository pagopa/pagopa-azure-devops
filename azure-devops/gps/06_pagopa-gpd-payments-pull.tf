variable "pagopa-gpd-payments-pull" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-gpd-payments-pull"
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
  pagopa-gpd-payments-pull-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-gpd-payments-pull.repository.branch_name
  }
  # global secrets
  pagopa-gpd-payments-pull-variables_secret = {
  }
  # performance vars
  pagopa-gpd-payments-pull-variables_performance_test = {
  }
  # performance secrets
  pagopa-gpd-payments-pull-variables_secret_performance_test = {
    DEV_API_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["integration-test-subkey"].value
    UAT_API_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["integration-test-subkey"].value
    PROD_API_SUBSCRIPTION_KEY = module.gps_prod_secrets.values["integration-test-subkey"].value
  }

}

module "pagopa-gpd-payments-pull_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-gpd-payments-pull.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-payments-pull.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-gpd-payments-pull"
  pipeline_name                = var.pagopa-gpd-payments-pull.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-gpd-payments-pull.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-gpd-payments-pull-variables,
    local.pagopa-gpd-payments-pull-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-gpd-payments-pull-variables_secret,
    local.pagopa-gpd-payments-pull-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
