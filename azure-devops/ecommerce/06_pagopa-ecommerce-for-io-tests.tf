variable "pagopa-ecommerce-api-tests" {
  default = {
    repository = {
      organization          = "pagopa"
      name                  = "pagopa-ecommerce-tests"
      branch_name           = "refs/heads/main"
      pipelines_path        = ".devops"
      yml_prefix_name       = null
      pipeline_yml_filename = "api-tests-ecommerce-for-io.yaml"
    }
    pipeline = {
      name = "api-tests-ecommerce-for-io"
    }
  }
}

locals {
  # global vars
  pagopa-ecommerce-api-tests-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-ecommerce-api-tests.repository.branch_name
  }
  # global secrets
  pagopa-ecommerce-api-tests-variables_secret = {
    dev_wallet_token_test = module.ecommerce_dev_secrets.values["wallet-token-test-key"].value
    uat_wallet_token_test = module.ecommerce_uat_secrets.values["wallet-token-test-key"].value
  }
  # soak vars
  pagopa-ecommerce-api-tests-variables_soak = {

  }
  # soak secrets
  pagopa-ecommerce-api-tests-variables_secret_soak = {
    wallet_token_test = module.ecommerce_uat_secrets.values["wallet-token-test-key"].value
  }

}

module "pagopa-api-tests-ecommerce-for-io" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-api-tests.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-ecommerce-tests"
  pipeline_name                = var.pagopa-ecommerce-api-tests.pipeline.name
  pipeline_yml_filename        = var.pagopa-ecommerce-api-tests.repository.pipeline_yml_filename

  variables = merge(
    local.pagopa-ecommerce-api-tests-variables,
    local.pagopa-ecommerce-api-tests-variables_soak,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-api-tests-variables_secret,
    local.pagopa-ecommerce-api-tests-variables_secret_soak,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
