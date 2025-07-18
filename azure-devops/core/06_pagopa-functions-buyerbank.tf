variable "pagopa-functions-buyerbank" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-functions-buyerbank"
      branch_name     = "refs/heads/master"
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
  pagopa-functions-buyerbank-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-functions-buyerbank.repository.branch_name
  }
  # global secrets
  pagopa-functions-buyerbank-variables_secret = {

  }
  # code_review vars
  pagopa-functions-buyerbank-variables_code_review = {
    danger_github_api_token = "skip"
  }
  # code_review secrets
  pagopa-functions-buyerbank-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-functions-buyerbankvariables_deploy = {
    git_mail                = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username            = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection       = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    dev_azure_subscription  = module.dev_azurerm_service_conn.service_endpoint_name
    uat_azure_subscription  = module.uat_azurerm_service_conn.service_endpoint_name
    prod_azure_subscription = module.prod_azurerm_service_conn.service_endpoint_name
    buyerbanks-api-key-dev  = module.secrets.values["DEV-BUYERBANKS-API-KEY"].value
    buyerbanks-api-key-uat  = module.secrets.values["UAT-BUYERBANKS-API-KEY"].value
    buyerbanks-api-key-prod = module.secrets.values["PROD-BUYERBANKS-API-KEY"].value
  }
  # deploy secrets
  pagopa-functions-buyerbank-variables_secret_deploy = {

  }
}

module "pagopa-functions-buyerbank_code_review" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_code_review"
  count  = var.pagopa-functions-buyerbank.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-functions-buyerbank.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.pagopa-functions-buyerbank.repository.name

  variables = merge(
    local.pagopa-functions-buyerbank-variables,
    local.pagopa-functions-buyerbank-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-functions-buyerbank-variables_secret,
    local.pagopa-functions-buyerbank-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id
  ]
}

module "pagopa-functions-buyerbank_deploy" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_deploy"
  count  = var.pagopa-functions-buyerbank.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-functions-buyerbank.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id
  path                         = var.pagopa-functions-buyerbank.repository.name


  variables = merge(
    local.pagopa-functions-buyerbank-variables,
    local.pagopa-functions-buyerbankvariables_deploy,
  )

  variables_secret = merge(
    local.pagopa-functions-buyerbank-variables_secret,
    local.pagopa-functions-buyerbank-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.dev_azurerm_service_conn.service_endpoint_id,
    module.uat_azurerm_service_conn.service_endpoint_id,
    module.prod_azurerm_service_conn.service_endpoint_id,
  ]
}
