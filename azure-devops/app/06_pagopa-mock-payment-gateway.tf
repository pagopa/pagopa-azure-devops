variable "pagopa-mock-payment-gateway" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-mock-payment-gateway"
      branch_name     = "refs/heads/master"
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
        project_key        = "pagopa_pagopa-mock-payment-gateway"
        project_name       = "pagopa-mock-payment-gateway"
      }
    }
  }
}

locals {
  # global vars
  pagopa-mock-payment-gateway-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-mock-payment-gateway.repository.branch_name
  }
  # global secrets
  pagopa-mock-payment-gateway-variables_secret = {

  }
  # code_review vars
  pagopa-mock-payment-gateway-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-mock-payment-gateway.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-mock-payment-gateway.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-mock-payment-gateway.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-mock-payment-gateway.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-mock-payment-gateway-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-mock-payment-gateway-variables_deploy = {
    git_mail                                      = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username                                  = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection                             = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    healthcheck_endpoint                          = "/actuator/health" #todo
    dev_deploy_type                               = "production_slot"  #or staging_slot_and_swap
    dev_azure_subscription                        = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    dev_healthcheck_container_resource_group_name = "NA"
    dev_healthcheck_container_vnet                = "NA"
    uat_deploy_type                               = "production_slot" #or staging_slot_and_swap
    uat_azure_subscription                        = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    uat_healthcheck_container_resource_group_name = "NA"
    uat_healthcheck_container_vnet                = "NA"
  }
  # deploy secrets
  pagopa-mock-payment-gateway-variables_secret_deploy = {

  }
}

module "pagopa-mock-payment-gateway_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.4"
  count  = var.pagopa-mock-payment-gateway.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-mock-payment-gateway.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-mock-payment-gateway-variables,
    local.pagopa-mock-payment-gateway-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-mock-payment-gateway-variables_secret,
    local.pagopa-mock-payment-gateway-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-mock-payment-gateway_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-mock-payment-gateway.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-mock-payment-gateway.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-mock-payment-gateway-variables,
    local.pagopa-mock-payment-gateway-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-mock-payment-gateway-variables_secret,
    local.pagopa-mock-payment-gateway-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
  ]
}
