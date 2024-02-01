variable "pagopa-checkout-tests" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-checkout-tests"
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
  pagopa-checkout-tests-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-checkout-tests.repository.branch_name
  }
  # global secrets
  pagopa-checkout-tests-variables_secret = {

  }
  # code_review vars
  pagopa-checkout-tests-variables_code_review = {
    danger_github_api_token = "skip"
  }
  # api-tests secrets
  pagopa-checkout-tests-variables_secret_code_review = {

  }
}

module "pagopa-checkout-tests_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-checkout-tests.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-checkout-tests.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id

  path = "${local.domain}\\pagopa-checkout-tests"

  variables = merge(
    local.pagopa-checkout-tests-variables,
    local.pagopa-checkout-tests-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-checkout-tests-variables_secret,
    local.pagopa-checkout-tests-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
