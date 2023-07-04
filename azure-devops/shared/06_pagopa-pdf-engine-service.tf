variable "pagopa-pdf-engine" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-pdf-engine"
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
  pagopa-pdf-engine-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-pdf-engine.repository.branch_name
  }
  # global secrets
  pagopa-pdf-engine-variables_secret = {

  }

  # performance vars
  pagopa-pdf-engine-variables_performance_test = {
  }
  # performance secrets
  pagopa-pdf-engine-variables_secret_performance_test = {
    DEV_SUBSCRIPTION_KEY = module.shared_dev_secrets.values["pdf-engine-d-perftest-subkey"].value
    UAT_SUBSCRIPTION_KEY = module.shared_uat_secrets.values["pdf-engine-u-perftest-subkey"].value
  }

}


module "pagopa-pdf-engine_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v2.6.3"
  count  = var.pagopa-pdf-engine.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-pdf-engine.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  path                         = "${local.domain}\\pagopa-pdf-engine"
  pipeline_name                = var.pagopa-pdf-engine.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-pdf-engine.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-pdf-engine-variables,
    local.pagopa-pdf-engine-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-pdf-engine-variables_secret,
    local.pagopa-pdf-engine-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]

}
