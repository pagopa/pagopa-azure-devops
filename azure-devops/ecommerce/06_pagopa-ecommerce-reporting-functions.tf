variable "pagopa-ecommerce-reporting-functions" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-ecommerce-reporting-functions"
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
  pagopa-ecommerce-reporting-functions-variables = {
    default_branch = var.pagopa-ecommerce-reporting-functions.repository.branch_name
  }
  # global secrets
  pagopa-ecommerce-reporting-functions-variables_secret = {

  }
  # code_review vars
  pagopa-ecommerce-reporting-functions-variables_code_review = {
  }
  # code_review secrets
  pagopa-ecommerce-reporting-functions-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-ecommerce-reporting-functions-variables_deploy = {
    git_mail                = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username            = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection       = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name
  }
  # deploy secrets
  pagopa-ecommerce-reporting-functions-variables_secret_deploy = {

  }
}

module "pagopa-ecommerce-reporting-functions_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-ecommerce-reporting-functions.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-reporting-functions.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id

  path = "${local.domain}\\pagopa-ecommerce-reporting-functions"

  variables = merge(
    local.pagopa-ecommerce-reporting-functions-variables,
    local.pagopa-ecommerce-reporting-functions-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-reporting-functions-variables_secret,
    local.pagopa-ecommerce-reporting-functions-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}

module "pagopa-ecommerce-reporting-functions_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-ecommerce-reporting-functions.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-reporting-functions.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id

  path = "${local.domain}\\pagopa-ecommerce-reporting-functions"

  variables = merge(
    local.pagopa-ecommerce-reporting-functions-variables,
    local.pagopa-ecommerce-reporting-functions-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-reporting-functions-variables_secret,
    local.pagopa-ecommerce-reporting-functions-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
