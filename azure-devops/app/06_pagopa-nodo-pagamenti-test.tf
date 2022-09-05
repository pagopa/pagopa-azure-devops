variable "pagopa-nodo-dei-pagamenti-test" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-nodo-dei-pagamenti-test"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = false
      sonarcloud = {
        # TODO azure devops terraform provider does not support SonarCloud service endpoint
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-nodo-dei-pagamenti-test"
        project_name       = "pagopa-nodo-dei-pagamenti-test"
      }
    }
  }
}

locals {
  # global vars
  pagopa-nodo-dei-pagamenti-test-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-nodo-dei-pagamenti-test.repository.branch_name
  }
  # global secrets
  pagopa-nodo-dei-pagamenti-test-variables_secret = {

  }
  # code_review vars
  pagopa-nodo-dei-pagamenti-test-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-nodo-dei-pagamenti-test.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-nodo-dei-pagamenti-test.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-nodo-dei-pagamenti-test.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-nodo-dei-pagamenti-test.pipeline.sonarcloud.project_name

    dev_azure_subscription_storage_account = "DEV-PAGOPA-SERVICE-CONN"
    dev_storage_account_name               = "pagopadnodotestsa"
    dev_resource_group_azure               = "pagopa-d-nodo-test-rg"
    dev_test_execution_max_minutes         = 120

    uat_azure_subscription_storage_account = "UAT-PAGOPA-SERVICE-CONN"
    uat_storage_account_name               = "pagopaunodotestsa"
    uat_resource_group_azure               = "pagopa-u-nodo-test-rg"
    uat_test_execution_max_minutes         = 120
  }
  # code_review secrets
  pagopa-nodo-dei-pagamenti-test-variables_secret_code_review = {
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-nodo-dei-pagamenti-test-variables_deploy = {
  }
  # deploy secrets
  pagopa-nodo-dei-pagamenti-test-variables_secret_deploy = {
  }
}

module "pagopa-nodo-dei-pagamenti-test_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-nodo-dei-pagamenti-test.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-nodo-dei-pagamenti-test.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.pagopa-nodo-dei-pagamenti-test-variables,
    local.pagopa-nodo-dei-pagamenti-test-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-nodo-dei-pagamenti-test-variables_secret,
    local.pagopa-nodo-dei-pagamenti-test-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-nodo-dei-pagamenti-test_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-nodo-dei-pagamenti-test.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-nodo-dei-pagamenti-test.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  ci_trigger_use_yaml = true

  variables = merge(
    local.pagopa-nodo-dei-pagamenti-test-variables,
    local.pagopa-nodo-dei-pagamenti-test-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-nodo-dei-pagamenti-test-variables_secret,
    local.pagopa-nodo-dei-pagamenti-test-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.id,
    azuredevops_serviceendpoint_dockerregistry.sia-docker-registry-dev.id,
    azuredevops_serviceendpoint_azurecr.acr_docker_registry_uat.id,
    azuredevops_serviceendpoint_dockerregistry.sia-docker-registry-uat.id,
    azuredevops_serviceendpoint_azurecr.acr_docker_registry_prod.id,
    azuredevops_serviceendpoint_dockerregistry.sia-docker-registry-prod.id,
  ]
}
