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
    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name
  }
  # deploy secrets
  pagopa-functions-checkout-variables_secret_deploy = {

  }
}

module "pagopa-functions-checkout_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-functions-checkout.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-functions-checkout.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id

  path = "${local.domain}\\pagopa-functions-checkout"

  variables = merge(
    local.pagopa-functions-checkout-variables,
    local.pagopa-functions-checkout-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-functions-checkout-variables_secret,
    local.pagopa-functions-checkout-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}

module "pagopa-functions-checkout_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-functions-checkout.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-functions-checkout.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id

  path = "${local.domain}\\pagopa-functions-checkout"

  variables = merge(
    local.pagopa-functions-checkout-variables,
    local.pagopa-functions-checkout-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-functions-checkout-variables_secret,
    local.pagopa-functions-checkout-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
