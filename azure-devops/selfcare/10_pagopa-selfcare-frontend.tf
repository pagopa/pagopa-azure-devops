variable "pagopa-selfcare-frontend" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-selfcare-frontend"
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
        project_key        = "pagopa_pagopa-selfcare-frontend"
        project_name       = "pagopa-selfcare-frontend"
      }
    }
  }
}

locals {
  # global vars
  pagopa-selfcare-frontend-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-selfcare-frontend.repository.branch_name
  }
  # global secrets
  pagopa-selfcare-frontend-variables_secret = {

  }
  # code_review vars
  pagopa-selfcare-frontend-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-selfcare-frontend.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-selfcare-frontend.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-selfcare-frontend.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-selfcare-frontend.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-selfcare-frontend-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-selfcare-frontend-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    blob_container_name = "$web"
    # apim_basepath_selfcare_marketplace_be      = "selfcare-marketplace/api"

    # DEV
    dev_selfcare_host                   = "https://dev.selfcare.pagopa.it"
    dev_selfcare_api_host               = "https://api.dev.platform.pagopa.it"
    dev_endpoint_azure                  = "pagopa-d-selfcare-cdn-endpoint"
    dev_profile_name_cdn_azure          = "pagopa-d-selfcare-cdn-profile"
    dev_storage_account_name            = "pagopadselfcaresa"
    dev_resource_group_azure            = "pagopa-d-fe-rg"
    dev_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.dev.id
    dev_react_app_url_fe_login          = "https://dev.selfcare.pagopa.it/auth"
    dev_react_app_url_fe_landing        = "https://dev.selfcare.pagopa.it/auth/logout"
    dev_react_app_url_fe_assistance     = "https://dev.selfcare.pagopa.it/assistenza"
    dev_react_app_url_api_portal        = "https://api.dev.platform.pagopa.it/selfcare/pagopa/v1/"
    dev_react_app_url_storage           = "https://pagopadselfcaresa.z6.web.core.windows.net/"
    dev_react_app_analytics_enabled     = "true"
    dev_react_app_analytics_mocked      = "false"
    dev_react_app_mixpanel_token        = "16e1290bdda5885981a2f443f37444f0f23"
    dev_react_app_onetrust_domain_id    = "a8f58d7a-7f6a-4fe6-ac02-f95bac3876d4-test"
    dev_react_app_url_fe_selfcare       = "https://dev.selfcare.pagopa.it/dashboard/"
    dev_react_app_url_fe_token_exchange = "https://dev.selfcare.pagopa.it/token-exchange"
    DEV_REACT_APP_URL_API_TOKEN         = "https://api.dev.platform.pagopa.it/api/token/token"

    # UAT
    uat_selfcare_host                   = "https://uat.selfcare.pagopa.it"
    uat_selfcare_api_host               = "https://api.uat.platform.pagopa.it"
    uat_endpoint_azure                  = "pagopa-u-selfcare-cdn-endpoint"
    uat_profile_name_cdn_azure          = "pagopa-u-selfcare-cdn-profile"
    uat_storage_account_name            = "pagopauselfcaresa"
    uat_resource_group_azure            = "pagopa-u-fe-rg"
    uat_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.uat.id
    uat_react_app_url_fe_login          = "https://uat.selfcare.pagopa.it/auth"
    uat_react_app_url_fe_landing        = "https://uat.selfcare.pagopa.it/auth/logout"
    uat_react_app_url_fe_assistance     = "https://uat.selfcare.pagopa.it/assistenza"
    uat_react_app_url_api_portal        = "https://api.uat.platform.pagopa.it/selfcare/pagopa/v1/"
    uat_react_app_url_storage           = "https://pagopauselfcaresa.z6.web.core.windows.net/"
    uat_react_app_analytics_enabled     = "true"
    uat_react_app_analytics_mocked      = "false"
    uat_react_app_mixpanel_token        = "1d1b09b008638080ab34fe9b75db84fd"
    uat_react_app_onetrust_domain_id    = "084d5de2-d423-458a-9b28-0f8db3e55e71"
    uat_react_app_url_fe_selfcare       = "https://uat.selfcare.pagopa.it/dashboard/"
    uat_react_app_url_fe_token_exchange = "https://uat.selfcare.pagopa.it/token-exchange"
    uat_react_app_url_api_token         = "https://api.uat.platform.pagopa.it/api/token/token"

    # PROD
    prod_selfcare_host                   = "https://selfcare.pagopa.it"
    prod_selfcare_api_host               = "https://api.platform.pagopa.it"
    prod_endpoint_azure                  = "pagopa-p-selfcare-cdn-endpoint"
    prod_profile_name_cdn_azure          = "pagopa-p-selfcare-cdn-profile"
    prod_storage_account_name            = "pagopapselfcaresa"
    prod_resource_group_azure            = "pagopa-p-fe-rg"
    prod_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.prod.id
    prod_react_app_url_fe_login          = "https://selfcare.pagopa.it/auth"
    prod_react_app_url_fe_landing        = "https://selfcare.pagopa.it/auth/logout"
    prod_react_app_url_fe_assistance     = "https://selfcare.pagopa.it/assistenza"
    prod_react_app_url_api_portal        = "https://api.platform.pagopa.it/selfcare/pagopa/v1/"
    prod_react_app_url_storage           = "https://pagopapselfcaresa.z6.web.core.windows.net/"
    prod_react_app_analytics_enabled     = "true"
    prod_react_app_analytics_mocked      = "false"
    prod_react_app_mixpanel_token        = "1d1b09b008638080ab34fe9b75db84fd"
    prod_react_app_onetrust_domain_id    = "084d5de2-d423-458a-9b28-0f8db3e55e71"
    prod_react_app_url_fe_selfcare       = "https://selfcare.pagopa.it/dashboard/"
    prod_react_app_url_fe_token_exchange = "https://selfcare.pagopa.it/token-exchange"
    prod_react_app_url_api_token         = "https://api.platform.pagopa.it/api/token/token"
  }
  # deploy secrets
  pagopa-selfcare-frontend-variables_secret_deploy = {
  }
}

module "pagopa-selfcare-frontend_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-selfcare-frontend.pipeline.enable_code_review == true ? 1 : 0

  project_id = data.azuredevops_project.project.id
  repository = var.pagopa-selfcare-frontend.repository
  # github_service_connection_id = data.azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-selfcare-backoffice-frontend"

  variables = merge(
    local.pagopa-selfcare-frontend-variables,
    local.pagopa-selfcare-frontend-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-selfcare-frontend-variables_secret,
    local.pagopa-selfcare-frontend-variables_secret_code_review,
  )

  service_connection_ids_authorization = [

    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-selfcare-frontend_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-selfcare-frontend.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-selfcare-frontend.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-selfcare-backoffice-frontend"

  variables = merge(
    local.pagopa-selfcare-frontend-variables,
    local.pagopa-selfcare-frontend-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-selfcare-frontend-variables_secret,
    local.pagopa-selfcare-frontend-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
