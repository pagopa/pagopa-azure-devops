variable "pagopa-mock-psp" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-mock-psp"
      branch_name     = "master"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      sonarcloud = {
        # TODO azure devops terraform provider does not support SonarCloud service endpoint
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-mock-psp"
        project_name       = "pagopa-mock-psp"
      }
    }
  }
}

locals {
  # global vars
  pagopa-mock-psp-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-mock-psp.repository.branch_name
  }
  # global secrets
  pagopa-mock-psp-variables_secret = {

  }
  # code_review vars
  pagopa-mock-psp-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-mock-psp.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-mock-psp.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-mock-psp.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-mock-psp.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-mock-psp-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-mock-psp-variables_deploy = {
    git_mail                                      = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username                                  = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection                             = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    healthcheck_endpoint                          = "/actuator/health" #todo
    dev_deploy_type                               = "production_slot"  #or staging_slot_and_swap
    dev_azure_subscription                        = azuredevops_serviceendpoint_azurerm.DEV-PAGOPA.service_endpoint_name
    dev_web_app_name                              = "pagopa-d-app-mock-psp"
    dev_web_app_resource_group_name               = "pagopa-d-mock-psp-rg"
    dev_healthcheck_container_resource_group_name = "NA"
    dev_healthcheck_container_vnet                = "NA"
    uat_deploy_type                               = "production_slot" #or staging_slot_and_swap
    uat_azure_subscription                        = azuredevops_serviceendpoint_azurerm.UAT-PAGOPA.service_endpoint_name
    uat_web_app_name                              = "pagopa-u-app-mock-psp"
    uat_web_app_resource_group_name               = "pagopa-u-mock-psp-rg"
    uat_healthcheck_container_resource_group_name = "NA"
    uat_healthcheck_container_vnet                = "NA"
  }
  # deploy secrets
  pagopa-mock-psp-variables_secret_deploy = {

  }
}

module "pagopa-mock-psp_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-mock-psp.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-mock-psp.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-mock-psp-variables,
    local.pagopa-mock-psp-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-mock-psp-variables_secret,
    local.pagopa-mock-psp-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-mock-psp_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-mock-psp.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-mock-psp.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-mock-psp-variables,
    local.pagopa-mock-psp-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-mock-psp-variables_secret,
    local.pagopa-mock-psp-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-PAGOPA.id,
    azuredevops_serviceendpoint_azurerm.UAT-PAGOPA.id,
  ]
}
