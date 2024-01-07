variable "pagopa-payments-tests" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-payments-tests"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
    }
  }
}

locals {
  # global vars
  pagopa-payments-tests-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-payments-tests.repository.branch_name
  }
  # global secrets
  pagopa-payments-tests-variables_secret = {

  }
  # code_review vars
  pagopa-payments-tests-variables_code_review = {
    danger_github_api_token = "skip"
  }
  # api-tests secrets
  pagopa-payments-tests-variables_secret_code_review = {

  }
}

module "pagopa-payments-tests_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.4"
  count  = var.pagopa-payments-tests.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-payments-tests.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-payments-tests-variables,
    local.pagopa-payments-tests-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-payments-tests-variables_secret,
    local.pagopa-payments-tests-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
  ]
}
