variable "pagopa-printit-tests" {
  default = {
    repository = {
      organization          = "pagopa"
      name                  = "pagopa-printit-tests"
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
  pagopa-printit-tests-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-printit-tests.repository.branch_name
  }
  # global secrets
  pagopa-printit-tests-variables_secret = {

  }
  # soak vars
  pagopa-printit-tests-variables_soak = {

  }
  # soak secrets
  pagopa-printit-tests-variables_secret_soak = {
    api_subscription_key_dev = module.printit_dev_secrets.values["printit-load-test-api-key"].value
    api_subscription_key_uat = module.printit_uat_secrets.values["printit-load-test-api-key"].value
  }

}

module "pagopa-printit-tests_soak" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-printit-tests.pipeline.enable_soak == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-printit-tests.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-printit-tests"
  pipeline_name                = var.pagopa-printit-tests.pipeline.name
  pipeline_yml_filename        = var.pagopa-printit-tests.repository.pipeline_yml_filename

  variables = merge(
    local.pagopa-printit-tests-variables,
    local.pagopa-printit-tests-variables_soak,
  )

  variables_secret = merge(
    local.pagopa-printit-tests-variables_secret,
    local.pagopa-printit-tests-variables_secret_soak,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
