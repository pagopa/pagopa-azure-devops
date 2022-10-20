variable "pagopa-payment-transactions-gateway" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-payment-transactions-gateway"
      branch_name     = "refs/heads/develop"
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
        project_key        = "pagopa_pagopa-payment-transactions-gateway"
        project_name       = "pagopa-payment-transactions-gateway"
      }
    }
  }
}

locals {
  # global vars
  pagopa-payment-transactions-gateway-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-payment-transactions-gateway.repository.branch_name
  }
  # global secrets
  pagopa-payment-transactions-gateway-variables_secret = {

  }
  # code_review vars
  pagopa-payment-transactions-gateway-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-payment-transactions-gateway.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-payment-transactions-gateway.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-payment-transactions-gateway.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-payment-transactions-gateway.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-payment-transactions-gateway-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-payment-transactions-gateway-variables_deploy = {

  }
  # deploy secrets
  pagopa-payment-transactions-gateway-variables_secret_deploy = {

  }
}

module "pagopa-payment-transactions-gateway_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.6.5"
  count  = var.pagopa-payment-transactions-gateway.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-payment-transactions-gateway.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  path                         = "pagopa-payment-transactions-gateway"

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.pagopa-payment-transactions-gateway-variables,
    local.pagopa-payment-transactions-gateway-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-payment-transactions-gateway-variables_secret,
    local.pagopa-payment-transactions-gateway-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}
