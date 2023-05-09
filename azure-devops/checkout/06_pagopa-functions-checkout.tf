variable "pagopa-functions-checkout" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-functions-checkout"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pagopa"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
    }
  }
}

locals {
  # global vars
  pagopa-functions-checkout-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-functions-checkout.repository.branch_name
  }
  # global secrets
  pagopa-functions-checkout-variables_secret = {

  }
  # code_review vars
  pagopa-functions-checkout-variables_code_review = {
    danger_github_api_token = "skip"
  }
  # code_review secrets
  pagopa-functions-checkout-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-functions-checkout-variables_deploy = {
    git_mail                = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username            = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection       = local.srv_endpoint_github_rw
    dev_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name
  }
  # deploy secrets
  pagopa-functions-checkout-variables_secret_deploy = {

  }
}

module "pagopa-functions-checkout_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-functions-checkout.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-functions-checkout.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id

  variables = merge(
    local.pagopa-functions-checkout-variables,
    local.pagopa-functions-checkout-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-functions-checkout-variables_secret,
    local.pagopa-functions-checkout-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}

module "pagopa-functions-checkout_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-functions-checkout.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-functions-checkout.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id

  variables = merge(
    local.pagopa-functions-checkout-variables,
    local.pagopa-functions-checkout-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-functions-checkout-variables_secret,
    local.pagopa-functions-checkout-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
  ]
}
