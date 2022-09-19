variable "pagopa-ecommerce-tests" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-ecommerce-tests"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_soak = true
    }
  }
}

locals {
  # global vars
  pagopa-ecommerce-tests-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-ecommerce-tests.repository.branch_name
  }
  # global secrets
  pagopa-ecommerce-tests-variables_secret = {

  }
  # soak vars
  pagopa-ecommerce-tests-variables_soak = {

  }
  # soak secrets
  pagopa-ecommerce-tests-variables_secret_soak = {

  }

}

module "pagopa-ecommerce-tests_soak" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.2.0"
  count  = var.pagopa-ecommerce-tests.pipeline.enable_soak == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-tests.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-ecommerce-tests"

  variables = merge(
    local.pagopa-ecommerce-tests-variables,
    local.pagopa-ecommerce-tests-variables_soak,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-tests-variables_secret,
    local.pagopa-ecommerce-tests-variables_secret_soak,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}
