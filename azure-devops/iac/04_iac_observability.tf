variable "observability_iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "observability"
    }
    pipeline = {
      enable_code_review   = true
      enable_deploy        = true
      path                 = "observability-infrastructure"
      pipeline_name_prefix = "observability-infra"
    }
  }
}

locals {
  # global vars
  observability_iac_variables = {

    TF_POOL_NAME_DEV  = "pagopa-dev-linux-infra",
    TF_POOL_NAME_UAT  = "pagopa-uat-linux-infra",
    TF_POOL_NAME_PROD = "pagopa-prod-linux-infra",
    #PLAN
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV  = module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_UAT  = module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_PROD = module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    #APPLY
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV  = module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT  = module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD = module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
  }
  # global secrets
  observability_iac_variables_secret = {}

  # code_review vars
  observability_iac_variables_code_review = {}
  # code_review secrets
  observability_iac_variables_secret_code_review = {}

  # deploy vars
  observability_iac_variables_deploy = {}
  # deploy secrets
  observability_iac_variables_secret_deploy = {}
}

module "observability_iac_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v7.0.0"
  count  = var.observability_iac.pipeline.enable_code_review == true ? 1 : 0
  path   = var.observability_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.observability_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.observability_iac.pipeline.pipeline_name_prefix

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.observability_iac_variables,
    local.observability_iac_variables_code_review,
  )

  variables_secret = merge(
    local.observability_iac_variables_secret,
    local.observability_iac_variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "observability_iac_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v7.0.0"
  count  = var.observability_iac.pipeline.enable_deploy == true ? 1 : 0
  path   = var.observability_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.observability_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.observability_iac.pipeline.pipeline_name_prefix

  ci_trigger_use_yaml           = false
  pull_request_trigger_use_yaml = false

  variables = merge(
    local.observability_iac_variables,
    local.observability_iac_variables_deploy,
  )

  variables_secret = merge(
    local.observability_iac_variables_secret,
    local.observability_iac_variables_secret_deploy,
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
