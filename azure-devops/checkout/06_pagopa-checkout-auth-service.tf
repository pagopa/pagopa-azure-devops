variable "pagopa-checkout-auth-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-checkout-auth-service"
      branch_name     = "refs/heads/main"
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
        project_key        = "pagopa_pagopa-checkout-auth-service"
        project_name       = "pagopa-checkout-auth-service"
      }
    }
  }
}

locals {
  # global vars
  pagopa-checkout-auth-service-variables = {
    default_branch   = var.pagopa-checkout-auth-service.repository.branch_name
  }
  # global secrets
  pagopa-checkout-auth-service-variables_secret = {

  }
  # code_review vars
  pagopa-checkout-auth-service-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-checkout-auth-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-checkout-auth-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-checkout-auth-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-checkout-auth-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-checkout-auth-service-variables_secret_code_review = {

  }
}

module "pagopa-checkout-auth-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-checkout-auth-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-checkout-auth-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-checkout-auth-service"

  variables = merge(
    local.pagopa-checkout-auth-service-variables,
    local.pagopa-checkout-auth-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-checkout-auth-service-variables_secret,
    local.pagopa-checkout-auth-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}
