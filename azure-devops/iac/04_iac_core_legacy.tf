##################################################
#         DO NOT COPY-PASTE THIS FILE
# use the new structured way to define the iac pipelines
# have a look at README.md
##################################################
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
    TF_POOL_NAME_DEV : "pagopa-dev-linux-infra",
    TF_POOL_NAME_UAT : "pagopa-uat-linux-infra",
    TF_POOL_NAME_PROD : "pagopa-prod-linux-infra",

    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV : module.DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_UAT : module.UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_PROD : module.PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_name,
  }
  # global secrets
  iac_core-variables_secret = {

  }

  # code_review vars
  iac_core-variables_code_review = {
  }
  # code_review secrets
  iac_core-variables_secret_code_review = {

  }

  # deploy vars
  iac_core-variables_deploy = {
    #APPLY
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV : azuredevops_serviceendpoint_azurerm.DEV-PAGOPA-IAC-LEGACY.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT : azuredevops_serviceendpoint_azurerm.UAT-PAGOPA-IAC-LEGACY.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD : azuredevops_serviceendpoint_azurerm.PROD-PAGOPA-IAC-LEGACY.service_endpoint_name,

  }
  # deploy secrets
  iac_core-variables_secret_deploy = {

  }
}

#
# Code review
#
module "iac_core_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v7.0.0"
  count  = var.iac_core.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.iac_core.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.iac_core.pipeline.path_name
  pipeline_name_prefix         = var.iac_core.repository.yml_prefix_name




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
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v7.0.0"
  count  = var.iac_core.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.iac_core.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.iac_core.pipeline.path_name
  pipeline_name_prefix         = var.iac_core.repository.yml_prefix_name




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
    module.DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_id,

    azuredevops_serviceendpoint_azurerm.DEV-PAGOPA-IAC-LEGACY.id,
    azuredevops_serviceendpoint_azurerm.UAT-PAGOPA-IAC-LEGACY.id,
    azuredevops_serviceendpoint_azurerm.PROD-PAGOPA-IAC-LEGACY.id,
  ]
}
