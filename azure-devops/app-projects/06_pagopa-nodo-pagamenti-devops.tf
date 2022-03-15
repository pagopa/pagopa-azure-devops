variable "pagopa-nodo4-nodo-dei-pagamenti-devops" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-nodo4-nodo-dei-pagamenti-devops"
      branch_name     = "main"
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
        project_key        = "pagopa_pagopa-nodo4-nodo-dei-pagamenti-devops"
        project_name       = "pagopa-nodo4-nodo-dei-pagamenti-devops"
      }
    }
  }
}

locals {
  # global vars
  pagopa-nodo4-nodo-dei-pagamenti-devops-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-nodo4-nodo-dei-pagamenti-devops.repository.branch_name
  }
  # global secrets
  pagopa-nodo4-nodo-dei-pagamenti-devops-variables_secret = {

  }
  # code_review vars
  pagopa-nodo4-nodo-dei-pagamenti-devops-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-nodo4-nodo-dei-pagamenti-devops.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-nodo4-nodo-dei-pagamenti-devops.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-nodo4-nodo-dei-pagamenti-devops.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-nodo4-nodo-dei-pagamenti-devops.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-nodo4-nodo-dei-pagamenti-devops-variables_secret_code_review = {
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-nodo4-nodo-dei-pagamenti-devops-variables_deploy = {
    git_mail                             = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username                         = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection                    = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    dev_container_registry_service_conn  = azuredevops_serviceendpoint_azurecr.pagopa-azurecr-dev.service_endpoint_name
    dev_container_registry_name          = "pagopadacr.azurecr.io"
    uat_container_registry_service_conn  = azuredevops_serviceendpoint_azurecr.pagopa-azurecr-uat.service_endpoint_name
    uat_container_registry_name          = "pagopauacr.azurecr.io"
    prod_container_registry_service_conn = azuredevops_serviceendpoint_azurecr.pagopa-azurecr-prod.service_endpoint_name
    prod_container_registry_name         = "pagopapacr.azurecr.io"

    dev_sia_registry_service_conn  = azuredevops_serviceendpoint_dockerregistry.sia-registry-dev.service_endpoint_name
    uat_sia_registry_service_conn  = azuredevops_serviceendpoint_dockerregistry.sia-registry-uat.service_endpoint_name
    prod_sia_registry_service_conn = azuredevops_serviceendpoint_dockerregistry.sia-registry-prod.service_endpoint_name

    sia_docker_registry = "docker-registry-default.ocp-tst-npaspc.sia.eu"
    sia_docker_username = "serviceaccount"
    sia_docker_password = module.secrets.values["DEV-SIA-DOCKER-REGISTRY-PWD"].value

  }
  # deploy secrets
  pagopa-nodo4-nodo-dei-pagamenti-devops-variables_secret_deploy = {

  }
}

module "pagopa-nodo4-nodo-dei-pagamenti-devops_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-nodo4-nodo-dei-pagamenti-devops.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-nodo4-nodo-dei-pagamenti-devops.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.pagopa-nodo4-nodo-dei-pagamenti-devops-variables,
    local.pagopa-nodo4-nodo-dei-pagamenti-devops-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-nodo4-nodo-dei-pagamenti-devops-variables_secret,
    local.pagopa-nodo4-nodo-dei-pagamenti-devops-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-nodo4-nodo-dei-pagamenti-devops_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-nodo4-nodo-dei-pagamenti-devops.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-nodo4-nodo-dei-pagamenti-devops.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  ci_trigger_use_yaml = true

  variables = merge(
    local.pagopa-nodo4-nodo-dei-pagamenti-devops-variables,
    local.pagopa-nodo4-nodo-dei-pagamenti-devops-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-nodo4-nodo-dei-pagamenti-devops-variables_secret,
    local.pagopa-nodo4-nodo-dei-pagamenti-devops-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurecr.pagopa-azurecr-dev.id,
    azuredevops_serviceendpoint_dockerregistry.sia-registry-dev.id,
    azuredevops_serviceendpoint_azurecr.pagopa-azurecr-uat.id,
    azuredevops_serviceendpoint_dockerregistry.sia-registry-uat.id,
    azuredevops_serviceendpoint_azurecr.pagopa-azurecr-prod.id,
    azuredevops_serviceendpoint_dockerregistry.sia-registry-prod.id,
  ]
}
