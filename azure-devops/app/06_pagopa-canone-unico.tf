variable "pagopa-canone-unico" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-canone-unico"
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
        project_key        = "pagopa_pagopa-canone-unico"
        project_name       = "pagopa-canone-unico"
      }
    }
  }
}

locals {
  # global vars
  pagopa-canone-unico-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-canone-unico.repository.branch_name
  }
  # global secrets
  pagopa-canone-unico-variables_secret = {

  }
  # code_review vars
  pagopa-canone-unico-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-canone-unico.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-canone-unico.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-canone-unico.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-canone-unico.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-canone-unico-variables_secret_code_review = {
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-canone-unico-variables_deploy = {
    git_mail                    = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username                = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection           = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    healthcheck_endpoint        = ""
    dev_deploy_type             = "production_slot" #or staging_slot_and_swap
    dev_azure_subscription      = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    dev_fn_name                 = "pagopa-d-fn-canoneunico"
    dev_fn_resource_group_name  = "pagopa-d-canoneunico-rg"
    uat_deploy_type             = "production_slot" #or staging_slot_and_swap
    uat_azure_subscription      = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    uat_fn_name                 = "pagopa-u-fn-canoneunico"
    uat_fn_resource_group_name  = "pagopa-u-canoneunico-rg"
    prod_deploy_type            = "production_slot" #or staging_slot_and_swap
    prod_azure_subscription     = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
    prod_fn_name                = "pagopa-p-fn-canoneunico"
    prod_fn_resource_group_name = "pagopa-p-canoneunico-rg"

    tenant_id = module.secrets.values["TENANTID"].value

    # acr section
    image_repository = "canone-unico"

    dev_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.service_endpoint_name
    uat_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_uat.service_endpoint_name
    prod_container_registry = azuredevops_serviceendpoint_azurecr.acr_docker_registry_prod.service_endpoint_name

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-canone-unico-variables_secret_deploy = {

  }
}

module "pagopa-canone-unico_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.4"
  count  = var.pagopa-canone-unico.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-canone-unico.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-canone-unico-variables,
    local.pagopa-canone-unico-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-canone-unico-variables_secret,
    local.pagopa-canone-unico-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-canone-unico_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.4"
  count  = var.pagopa-canone-unico.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-canone-unico.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-canone-unico-variables,
    local.pagopa-canone-unico-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-canone-unico-variables_secret,
    local.pagopa-canone-unico-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
