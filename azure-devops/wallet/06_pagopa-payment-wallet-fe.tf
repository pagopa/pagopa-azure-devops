variable "pagopa-payment-wallet-fe" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-wallet-fe"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pagopa"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      sonarcloud = {
        # TODO azure devops terraform provider does not support SonarCloud service endpoint
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-wallet-fe"
        project_name       = "pagopa-wallet-fe"
      }
    }
  }
}

locals {
  # global vars
  pagopa-payment-wallet-fe-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-payment-wallet-fe.repository.branch_name
  }
  # global secrets
  pagopa-payment-wallet-fe-variables_secret = {

  }
  # code_review vars
  pagopa-payment-wallet-fe-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-payment-wallet-fe.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-payment-wallet-fe.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-payment-wallet-fe.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-payment-wallet-fe.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-payment-wallet-fe-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-payment-wallet-fe-variables_deploy = {
    github_connection       = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name
    cache_version_id        = "v1"
    api_host_dev            = "https://api.dev.platform.pagopa.it"
    api_host_uat            = "https://api.uat.platform.pagopa.it"
    api_host_prod           = "https://api.platform.pagopa.it"
  }
  # deploy secrets
  pagopa-payment-wallet-fe-variables_secret_deploy = {
    git_mail     = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
  }
}

module "pagopa-payment-wallet-fe_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-payment-wallet-fe.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id

  path = "${local.domain}\\pagopa-payment-wallet-fe"

  variables = merge(
    local.pagopa-payment-wallet-fe-variables,
    local.pagopa-payment-wallet-fe-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-payment-wallet-fe-variables_secret,
    local.pagopa-payment-wallet-fe-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-payment-wallet-fe_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-payment-wallet-fe.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id

  path = "${local.domain}\\pagopa-payment-wallet-fe"

  variables = merge(
    local.pagopa-payment-wallet-fe-variables,
    local.pagopa-payment-wallet-fe-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-payment-wallet-fe-variables_secret,
    local.pagopa-payment-wallet-fe-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    #data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
