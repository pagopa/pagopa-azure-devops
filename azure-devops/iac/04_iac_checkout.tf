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
    tf_dev_azure_service_connection  = azuredevops_serviceendpoint_azurerm.DEV-PAGOPA-IAC-LEGACY.service_endpoint_name
    tf_uat_azure_service_connection  = azuredevops_serviceendpoint_azurerm.UAT-PAGOPA-IAC-LEGACY.service_endpoint_name
    tf_prod_azure_service_connection = azuredevops_serviceendpoint_azurerm.PROD-PAGOPA-IAC-LEGACY.service_endpoint_name

    TF_POOL_NAME_DEV : "pagopa-dev-linux-infra",
    TF_POOL_NAME_UAT : "pagopa-uat-linux-infra",
    TF_POOL_NAME_PROD : "pagopa-prod-linux-infra",
    #PLAN
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV : module.DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_UAT : module.UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_PROD : module.PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_name,
    #APPLY
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV : azuredevops_serviceendpoint_azurerm.DEV-PAGOPA-IAC-LEGACY.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT : azuredevops_serviceendpoint_azurerm.UAT-PAGOPA-IAC-LEGACY.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD : azuredevops_serviceendpoint_azurerm.PROD-PAGOPA-IAC-LEGACY.service_endpoint_name,

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
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.5.0"
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
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "checkout_iac_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v5.5.0"
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
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,

    module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
  ]
}
