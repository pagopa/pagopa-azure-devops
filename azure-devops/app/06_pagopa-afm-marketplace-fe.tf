variable "pagopa-afm-marketplace-fe" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-afm-marketplace-fe"
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
        project_key        = "pagopa_pagopa-afm-marketplace-fe"
        project_name       = "pagopa-afm-marketplace-fe"
      }
    }
  }
}

locals {
  # global vars
  pagopa-afm-marketplace-fe-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-afm-marketplace-fe.repository.branch_name
  }
  # global secrets
  pagopa-afm-marketplace-fe-variables_secret = {

  }
  # code_review vars
  pagopa-afm-marketplace-fe-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-afm-marketplace-fe.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-afm-marketplace-fe.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-afm-marketplace-fe.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-afm-marketplace-fe.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-afm-marketplace-fe-variables_secret_code_review = {
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-afm-marketplace-fe-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name

    blob_container_name              = "$web"
    apim_basepath_afm_marketplace_be = "afm-marketplace/api"

    dev_afm_api_host                       = "https://api.dev.platform.pagopa.it"
    dev_endpoint_azure                     = "pagopa-d-afm-fe-cdn-endpoint"
    dev_profile_name_cdn_azure             = "pagopa-d-afm-fe-cdn-profile"
    dev_storage_account_name               = "pagopadafmfesa"
    dev_resource_group_azure               = "pagopa-d-afm-rg"
    dev_azure_subscription_storage_account = "DEV-PAGOPA-SERVICE-CONN"

  }
  # deploy secrets
  pagopa-afm-marketplace-fe-variables_secret_deploy = {

  }
}

module "pagopa-afm-marketplace-fe_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.4"
  count  = var.pagopa-afm-marketplace-fe.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-afm-marketplace-fe.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-afm-marketplace-fe-variables,
    local.pagopa-afm-marketplace-fe-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-afm-marketplace-fe-variables_secret,
    local.pagopa-afm-marketplace-fe-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-afm-marketplace-fe_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.4"
  count  = var.pagopa-afm-marketplace-fe.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-afm-marketplace-fe.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-afm-marketplace-fe-variables,
    local.pagopa-afm-marketplace-fe-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-afm-marketplace-fe-variables_secret,
    local.pagopa-afm-marketplace-fe-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
  ]
}
