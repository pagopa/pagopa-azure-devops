variable "iac_next_core" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "next-core"
    }
    pipeline = {
      enable_code_review   = true
      enable_deploy        = true
      path_name            = "next-core-infra"
      pipeline_name_prefix = "next-core-infra"
    }
  }
}

locals {
  # global vars
  iac_next_core-variables = {
    TF_POOL_NAME_DEV : "pagopa-dev-linux-infra",
    TF_POOL_NAME_UAT : "pagopa-uat-linux-infra",
    TF_POOL_NAME_PROD : "pagopa-prod-linux-infra",
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV : module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_UAT : module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_PROD : module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
  }
  # global secrets
  iac_next_core-variables_secret = {

  }

  # code_review vars
  iac_next_core-variables_code_review = {
  }
  # code_review secrets
  iac_next_core-variables_secret_code_review = {

  }

  # deploy vars
  iac_next_core-variables_deploy = {
    #APPLY
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV : module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT : module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD : module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,

  }
  # deploy secrets
  iac_next_core-variables_secret_deploy = {

  }
}

#
# Code review
#
module "iac_next_core_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v6.0.0"
  count  = var.iac_next_core.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.iac_next_core.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.iac_next_core.pipeline.path_name
  pipeline_name_prefix         = var.iac_next_core.pipeline.pipeline_name_prefix

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.iac_next_core-variables,
    local.iac_next_core-variables_code_review,
  )

  variables_secret = merge(
    local.iac_next_core-variables_secret,
    local.iac_next_core-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

#
# DEPLOY
#
module "iac_next_core_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v6.0.0"
  count  = var.iac_next_core.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.iac_next_core.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.iac_next_core.pipeline.path_name
  pipeline_name_prefix         = var.iac_next_core.pipeline.pipeline_name_prefix

  ci_trigger_use_yaml           = false
  pull_request_trigger_use_yaml = false


  variables = merge(
    local.iac_next_core-variables,
    local.iac_next_core-variables_deploy,
  )

  variables_secret = merge(
    local.iac_next_core-variables_secret,
    local.iac_next_core-variables_secret_deploy,
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
