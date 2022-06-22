variable "pagopa-spontaneous-payments" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-spontaneous-payments"
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
        project_key        = "pagopa_pagopa-spontaneous-payments"
        project_name       = "pagopa-spontaneous-payments"
      }
    }
  }
}

locals {
  # global vars
  pagopa-spontaneous-payments-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-spontaneous-payments.repository.branch_name
  }
  # global secrets
  pagopa-spontaneous-payments-variables_secret = {

  }
  # code_review vars
  pagopa-spontaneous-payments-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-spontaneous-payments.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-spontaneous-payments.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-spontaneous-payments.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-spontaneous-payments.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-spontaneous-payments-variables_secret_code_review = {
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-spontaneous-payments-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section 
    image_repository                    = "api-spontaneous-payments-backend"
    dev_container_registry_service_conn = ""
    k8s_image_repository_name           = ""
    dev_container_registry_name         = ""

    dev_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.service_endpoint_name
    uat_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_uat.service_endpoint_name
    prod_container_registry = azuredevops_serviceendpoint_azurecr.acr_docker_registry_prod.service_endpoint_name

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-spontaneous-payments-variables_secret_deploy = {

  }
}

module "pagopa-spontaneous-payments_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-spontaneous-payments.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-spontaneous-payments.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-spontaneous-payments-variables,
    local.pagopa-spontaneous-payments-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-spontaneous-payments-variables_secret,
    local.pagopa-spontaneous-payments-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-spontaneous-payments_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-spontaneous-payments.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-spontaneous-payments.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-spontaneous-payments-variables,
    local.pagopa-spontaneous-payments-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-spontaneous-payments-variables_secret,
    local.pagopa-spontaneous-payments-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}

