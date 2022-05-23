variable "pagopa-ecommerce-transactions-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-ecommerce-transactions-service"
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
        project_key        = "pagopa_pagopa-ecommerce-transactions-service"
        project_name       = "pagopa-ecommerce-transactions-service"
      }
    }
  }
}

locals {
  # global vars
  pagopa-ecommerce-transactions-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-ecommerce-transactions-service.repository.branch_name
  }
  # global secrets
  pagopa-ecommerce-transactions-service-variables_secret = {

  }
  # code_review vars
  pagopa-ecommerce-transactions-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-ecommerce-transactions-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-ecommerce-transactions-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-ecommerce-transactions-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-ecommerce-transactions-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-ecommerce-transactions-service-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-ecommerce-transactions-service-variables_deploy = {
    github_connection = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    image_repository = "pagopa-ecommerce-transactions-service"

    dev_container_registry  = azuredevops_serviceendpoint_azurecr.acr_aks_dev.service_endpoint_name
    uat_container_registry  = azuredevops_serviceendpoint_azurecr.acr_aks_uat.service_endpoint_name
    prod_container_registry = azuredevops_serviceendpoint_azurecr.acr_aks_prod.service_endpoint_name

    dev_container_namespace  = "pagopapcommonacr.azurecr.io"
    uat_container_namespace  = "pagopapcommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-ecommerce-transactions-service-variables_secret_deploy = {

  }
}

module "pagopa-ecommerce-transactions-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-ecommerce-transactions-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-transactions-service.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-ecommerce-transactions-service-variables,
    local.pagopa-ecommerce-transactions-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-transactions-service-variables_secret,
    local.pagopa-ecommerce-transactions-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-ecommerce-transactions-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-ecommerce-transactions-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-transactions-service.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-ecommerce-transactions-service-variables,
    local.pagopa-ecommerce-transactions-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-transactions-service-variables_secret,
    local.pagopa-ecommerce-transactions-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurecr.acr_aks_dev.id,
    azuredevops_serviceendpoint_azurecr.acr_aks_uat.id,
    azuredevops_serviceendpoint_azurecr.acr_aks_prod.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
