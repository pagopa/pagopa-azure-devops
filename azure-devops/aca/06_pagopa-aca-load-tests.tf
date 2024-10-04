variable "pagopa-aca-tests" {
  default = {
    repository = {
      organization          = "pagopa"
      name                  = "pagopa-aca-tests"
      branch_name           = "refs/heads/main"
      pipelines_path        = ".devops"
      yml_prefix_name       = null
      pipeline_yml_filename = "soaktest.yaml"
    }
    pipeline = {
      enable_soak = true
      name        = "soak-test-pipeline"
    }
  }
}

locals {
  # global vars
  pagopa-aca-tests-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-aca-tests.repository.branch_name
  }
  # global secrets
  pagopa-aca-tests-variables_secret = {

  }
  # soak vars
  pagopa-aca-tests-variables_soak = {

  }
  # soak secrets
  pagopa-aca-tests-variables_secret_soak = {
    api_subscription_key_dev = module.aca_dev_secrets.values["aca-load-test-api-key"].value
    api_subscription_key_uat = module.aca_uat_secrets.values["aca-load-test-api-key"].value
  }

}

module "pagopa-aca-tests_soak" {
      source = "./.terraform/modules/__azdo__/azuredevops_build_definition_generic"

  count  = var.pagopa-aca-tests.pipeline.enable_soak == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-aca-tests.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-aca-tests"
  pipeline_name                = var.pagopa-aca-tests.pipeline.name
  pipeline_yml_filename        = var.pagopa-aca-tests.repository.pipeline_yml_filename

  variables = merge(
    local.pagopa-aca-tests-variables,
    local.pagopa-aca-tests-variables_soak,
  )

  variables_secret = merge(
    local.pagopa-aca-tests-variables_secret,
    local.pagopa-aca-tests-variables_secret_soak,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
