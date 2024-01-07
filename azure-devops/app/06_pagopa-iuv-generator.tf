variable "pagopa-iuv-generator" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-iuv-generator"
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
        project_key        = "pagopa_pagopa-iuv-generator"
        project_name       = "pagopa-iuv-generator"
      }
    }
  }
}

locals {
  # global vars
  pagopa-iuv-generator-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-iuv-generator.repository.branch_name
  }
  # global secrets
  pagopa-iuv-generator-variables_secret = {

  }
  # code_review vars
  pagopa-iuv-generator-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-iuv-generator.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-iuv-generator.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-iuv-generator.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-iuv-generator.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-iuv-generator-variables_secret_code_review = {
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-iuv-generator-variables_deploy = {
    git_mail                = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username            = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection       = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    healthcheck_endpoint    = "/api/v1/info"
    dev_azure_subscription  = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    dev_web_app_name        = "pagopa-d"
    uat_azure_subscription  = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    uat_web_app_name        = "pagopa-u"
    prod_azure_subscription = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
    prod_web_app_name       = "pagopa-p"

    tenant_id = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository = "iuv-generator"

    dev_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.service_endpoint_name
    uat_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_uat.service_endpoint_name
    prod_container_registry = azuredevops_serviceendpoint_azurecr.acr_docker_registry_prod.service_endpoint_name

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-iuv-generator-variables_secret_deploy = {

  }
}

module "pagopa-iuv-generator_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.4"
  count  = var.pagopa-iuv-generator.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-iuv-generator.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
      path                         = var.pagopa-iuv-generator.repository.name

  variables = merge(
    local.pagopa-iuv-generator-variables,
    local.pagopa-iuv-generator-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-iuv-generator-variables_secret,
    local.pagopa-iuv-generator-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-iuv-generator_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.4"
  count  = var.pagopa-iuv-generator.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-iuv-generator.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id
      path                         = var.pagopa-iuv-generator.repository.name


  variables = merge(
    local.pagopa-iuv-generator-variables,
    local.pagopa-iuv-generator-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-iuv-generator-variables_secret,
    local.pagopa-iuv-generator-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
