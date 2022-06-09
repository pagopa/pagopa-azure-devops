variable "pagopa-afm-marketplace-be" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-afm-marketplace-be"
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
        project_key        = "pagopa_pagopa-afm-marketplace-be"
        project_name       = "pagopa-afm-marketplace-be"
      }
    }
  }
}

locals {
  # global vars
  pagopa-afm-marketplace-be-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-afm-marketplace-be.repository.branch_name
  }
  # global secrets
  pagopa-afm-marketplace-be-variables_secret = {

  }
  # code_review vars
  pagopa-afm-marketplace-be-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-afm-marketplace-be.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-afm-marketplace-be.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-afm-marketplace-be.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-afm-marketplace-be.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-afm-marketplace-be-variables_secret_code_review = {
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-afm-marketplace-be-variables_deploy = {
    git_mail                         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username                     = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection                = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    healthcheck_endpoint             = "/api/v1/info"
    dev_deploy_type                  = "production_slot" #or staging_slot_and_swap
    dev_azure_subscription           = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    dev_web_app_name                 = "pagopa-d-app-afm"
    dev_web_app_resource_group_name  = "pagopa-d-afm-rg"
    uat_deploy_type                  = "production_slot" #or staging_slot_and_swap
    uat_azure_subscription           = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    uat_web_app_name                 = "pagopa-u-app-afm"
    uat_web_app_resource_group_name  = "pagopa-u-afm-rg"
    prod_deploy_type                 = "production_slot" #or staging_slot_and_swap
    prod_azure_subscription          = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
    prod_web_app_name                = "pagopa-p-app-afm"
    prod_web_app_resource_group_name = "pagopa-p-afm-rg"

    tenant_id                   = module.secrets.values["TENANTID"].value
    dev_afm_client_fe_id        = module.secrets.values["DEV-AFM-CLIENT-ID"].value
    dev_afm_client_fe_secret    = module.secrets.values["DEV-AFM-CLIENT-SECRECT"].value
    dev_afm_client_be_resource  = module.secrets.values["DEV-AFM-BE-CLIENT-ID"].value
    uat_afm_client_fe_id        = module.secrets.values["UAT-AFM-CLIENT-ID"].value
    uat_afm_client_fe_secret    = module.secrets.values["UAT-AFM-CLIENT-SECRECT"].value
    uat_afm_client_be_resource  = module.secrets.values["UAT-AFM-BE-CLIENT-ID"].value
    prod_afm_client_fe_id       = module.secrets.values["PROD-AFM-CLIENT-ID"].value
    prod_afm_client_fe_secret   = module.secrets.values["PROD-AFM-CLIENT-SECRECT"].value
    prod_afm_client_be_resource = module.secrets.values["PROD-AFM-BE-CLIENT-ID"].value

    # acr section
    image_repository = "api-afm-backend"

    dev_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.service_endpoint_name
    uat_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_uat.service_endpoint_name
    prod_container_registry = azuredevops_serviceendpoint_azurecr.acr_docker_registry_prod.service_endpoint_name

    dev_container_namespace  = "pagopadacr.azurecr.io"
    uat_container_namespace  = "pagopauacr.azurecr.io"
    prod_container_namespace = "pagopapacr.azurecr.io"

  }
  # deploy secrets
  pagopa-afm-marketplace-be-variables_secret_deploy = {

  }
}

module "pagopa-afm-marketplace-be_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-afm-marketplace-be.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-afm-marketplace-be.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-afm-marketplace-be-variables,
    local.pagopa-afm-marketplace-be-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-afm-marketplace-be-variables_secret,
    local.pagopa-afm-marketplace-be-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-afm-marketplace-be_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-afm-marketplace-be.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-afm-marketplace-be.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-afm-marketplace-be-variables,
    local.pagopa-afm-marketplace-be-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-afm-marketplace-be-variables_secret,
    local.pagopa-afm-marketplace-be-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
