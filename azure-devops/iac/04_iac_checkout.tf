variable "checkout_iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "checkout"
    }
    pipeline = {
      enable_code_review   = true
      enable_deploy        = true
      path                 = "checkout-infrastructure"
      pipeline_name_prefix = "checkout-infra"
    }
  }
}

locals {
  # global vars
  checkout_iac_variables = {
    tf_dev_azure_service_connection  = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    tf_uat_azure_service_connection  = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    tf_prod_azure_service_connection = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
  }
  # global secrets
  checkout_iac_variables_secret = {}

  # code_review vars
  checkout_iac_variables_code_review = {}
  # code_review secrets
  checkout_iac_variables_secret_code_review = {}

  # deploy vars
  checkout_iac_variables_deploy = {}
  # deploy secrets
  checkout_iac_variables_secret_deploy = {}
}

module "checkout_iac_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.6.2"
  count  = var.checkout_iac.pipeline.enable_code_review == true ? 1 : 0
  path   = var.checkout_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.checkout_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.checkout_iac.pipeline.pipeline_name_prefix

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.checkout_iac_variables,
    local.checkout_iac_variables_code_review,
  )

  variables_secret = merge(
    local.checkout_iac_variables_secret,
    local.checkout_iac_variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}

module "checkout_iac_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.6.2"
  count  = var.checkout_iac.pipeline.enable_deploy == true ? 1 : 0
  path   = var.checkout_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.checkout_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.checkout_iac.pipeline.pipeline_name_prefix

  ci_trigger_use_yaml           = false
  pull_request_trigger_use_yaml = false

  variables = merge(
    local.checkout_iac_variables,
    local.checkout_iac_variables_deploy,
  )

  variables_secret = merge(
    local.checkout_iac_variables_secret,
    local.checkout_iac_variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
