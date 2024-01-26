variable "iac_core" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "core"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      path_name          = "core-infra"
    }
  }
}

locals {
  # global vars
  iac_core-variables = {

  }
  # global secrets
  iac_core-variables_secret = {

  }

  # code_review vars
  iac_core-variables_code_review = {
    TF_POOL_NAME_DEV : "pagopa-dev-linux-infra",
    TF_POOL_NAME_UAT : "pagopa-uat-linux-infra",
    TF_POOL_NAME_PROD : "pagopa-prod-linux-infra",
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV : "AZDO-DEV-PAGOPA-IAC-PLAN-SERVICE-CONN",
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_UAT : "AZDO-UAT-PAGOPA-IAC-PLAN-SERVICE-CONN",
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_PROD : "AZDO-PROD-PAGOPA-IAC-PLAN-SERVICE-CONN",
  }
  # code_review secrets
  iac_core-variables_secret_code_review = {

  }

  # deploy vars
  iac_core-variables_deploy = {
    #APPLY
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV : "AZDO-DEV-PAGOPA-IAC-DEPLOY-SERVICE-CONN",
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT : "AZDO-UAT-PAGOPA-IAC-DEPLOY-SERVICE-CONN",
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD : "AZDO-PROD-PAGOPA-IAC-DEPLOY-SERVICE-CONN",

  }
  # deploy secrets
  iac_core-variables_secret_deploy = {

  }
}

#
# Code review
#
module "iac_core_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.2.0"
  count  = var.iac_core.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.iac_core.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.iac_core.pipeline.path_name

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.iac_core-variables,
    local.iac_core-variables_code_review,
  )

  variables_secret = merge(
    local.iac_core-variables_secret,
    local.iac_core-variables_secret_code_review,
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
module "iac_core_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v5.2.0"
  count  = var.iac_core.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.iac_core.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.iac_core.pipeline.path_name

  ci_trigger_use_yaml           = false
  pull_request_trigger_use_yaml = false


  variables = merge(
    local.iac_core-variables,
    local.iac_core-variables_deploy,
  )

  variables_secret = merge(
    local.iac_core-variables_secret,
    local.iac_core-variables_secret_deploy,
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
