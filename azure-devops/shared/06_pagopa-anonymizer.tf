variable "pagopa-anonymizer" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-anonymizer"
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
  pagopa-anonymizer-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-anonymizer.repository.branch_name
  }
  # global secrets
  pagopa-anonymizer-variables_secret = {

  }
  # performance vars
  pagopa-anonymizer-variables_performance_test = {
  }
  # performance secrets
  pagopa-anonymizer-variables_secret_performance_test = {
    DEV_SUBSCRIPTION_KEY = module.shared_dev_secrets.values["shared-anonymizer-api-key"].value
    UAT_SUBSCRIPTION_KEY = module.shared_uat_secrets.values["shared-anonymizer-api-key"].value
  }

}

module "pagopa-anonymizer_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-anonymizer.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-anonymizer.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-anonymizer"
  pipeline_name                = var.pagopa-anonymizer.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-anonymizer.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-anonymizer-variables,
    local.pagopa-anonymizer-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-anonymizer-variables_secret,
    local.pagopa-anonymizer-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]

}
