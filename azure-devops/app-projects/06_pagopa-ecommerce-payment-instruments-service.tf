variable "pagopa-ecommerce-payment-instruments-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-ecommerce-payment-instruments-service"
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
        project_key        = "pagopa_pagopa-ecommerce-payment-instruments-service"
        project_name       = "pagopa-ecommerce-payment-instruments-service"
      }
    }
  }
}

locals {
  # global vars
  pagopa-ecommerce-payment-instruments-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-ecommerce-payment-instruments-service.repository.branch_name
  }
  # global secrets
  pagopa-ecommerce-payment-instruments-service-variables_secret = {

  }
  # code_review vars
  pagopa-ecommerce-payment-instruments-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-ecommerce-payment-instruments-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-ecommerce-payment-instruments-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-ecommerce-payment-instruments-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-ecommerce-payment-instruments-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-ecommerce-payment-instruments-service-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-ecommerce-payment-instruments-service-variables_deploy = {

  }
  # deploy secrets
  pagopa-ecommerce-payment-instruments-service-variables_secret_deploy = {

  }
}

module "pagopa-ecommerce-payment-instruments-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-ecommerce-payment-instruments-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-payment-instruments-service.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-ecommerce-payment-instruments-service-variables,
    local.pagopa-ecommerce-payment-instruments-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-payment-instruments-service-variables_secret,
    local.pagopa-ecommerce-payment-instruments-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}