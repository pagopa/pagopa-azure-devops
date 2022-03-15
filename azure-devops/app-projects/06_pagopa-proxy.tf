variable "pagopa-proxy" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "io-pagopa-proxy"
      branch_name     = "main"
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
  pagopa-proxy-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-proxy.repository.branch_name
  }
  # global secrets
  pagopa-proxy-variables_secret = {

  }
  # code_review vars
  pagopa-proxy-variables_code_review = {
    danger_github_api_token = "skip"
  }
  # code_review secrets
  pagopa-proxy-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-proxy-variables_deploy = {
    git_mail                = module.secrets.values["io-azure-devops-github-EMAIL"].value
    git_username            = module.secrets.values["io-azure-devops-github-USERNAME"].value
    github_connection       = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    dev_azure_subscription  = azuredevops_serviceendpoint_azurerm.DEV-PAGOPA.service_endpoint_name
    uat_azure_subscription  = azuredevops_serviceendpoint_azurerm.UAT-PAGOPA.service_endpoint_name
    prod_azure_subscription = azuredevops_serviceendpoint_azurerm.PROD-PAGOPA.service_endpoint_name
  }
  # deploy secrets
  pagopa-proxy-variables_secret_deploy = {

  }
}

module "pagopa-proxy_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-proxy.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-proxy.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-proxy-variables,
    local.pagopa-proxy-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-proxy-variables_secret,
    local.pagopa-proxy-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id
  ]
}

module "pagopa-proxy_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-proxy.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-proxy.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-proxy-variables,
    local.pagopa-proxy-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-proxy-variables_secret,
    local.pagopa-proxy-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-PAGOPA.id,
    azuredevops_serviceendpoint_azurerm.UAT-PAGOPA.id,
    azuredevops_serviceendpoint_azurerm.PROD-PAGOPA.id,
  ]
}
