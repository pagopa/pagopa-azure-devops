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
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-selfcare-frontend-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name

    blob_container_name = "$web"
    # apim_basepath_selc_marketplace_be      = "selc-marketplace/api"

    # DEV
    dev_selc_api_host                = "https://api.dev.platform.pagopa.it"
    dev_endpoint_azure               = "pagopa-d-weu-selc-selc-cdn-endpoint"
    dev_profile_name_cdn_azure       = "pagopa-d-weu-selc-selc-cdn-profile"
    dev_storage_account_name         = "pagopadweuselcselcsa"
    dev_resource_group_azure         = "pagopa-d-weu-selc-selc-fe-rg"
    dev_azure_subscription           = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id
    dev_react_app_url_fe_login       = "https://dev.selfcare.pagopa.it/auth"
    dev_react_app_url_fe_landing     = "https://dev.selfcare.pagopa.it/auth/logout"
    dev_react_app_url_fe_assistance  = "https://dev.selfcare.pagopa.it/assistenza"
    dev_react_app_url_api_portal     = "https://api.dev.platform.pagopa.it/selc/pagopa/v1/"
    dev_react_app_url_storage        = "https://pagopadweuselcselcsa.z6.web.core.windows.net/"
    dev_react_app_analytics_enabled  = "true"
    dev_react_app_analytics_mocked   = "false"
    dev_react_app_mixpanel_token     = "16e1290bdda5885981a2f443f37444f0f23"
    dev_react_app_onetrust_domain_id = "a8f58d7a-7f6a-4fe6-ac02-f95bac3876d4-test"

    # PROD
    prod_selc_api_host                = "https://api.platform.pagopa.it"
    prod_endpoint_azure               = "pagopa-p-weu-selc-selc-cdn-endpoint"
    prod_profile_name_cdn_azure       = "pagopa-p-weu-selc-selc-cdn-profile"
    prod_storage_account_name         = "pagopapweuselcselcsa"
    prod_resource_group_azure         = "pagopa-p-weu-selc-selc-fe-rg"
    prod_azure_subscription           = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id
    prod_react_app_url_fe_login       = "https://selfcare.pagopa.it/auth"
    prod_react_app_url_fe_landing     = "https://selfcare.pagopa.it/auth/logout"
    prod_react_app_url_fe_assistance  = "https://selfcare.pagopa.it/assistenza"
    prod_react_app_url_api_portal     = "https://api.platform.pagopa.it/selc/pagopa/v1/"
    prod_react_app_url_storage        = "https://pagopapweuselcselcsa.z6.web.core.windows.net/"
    prod_react_app_analytics_enabled  = "true"
    prod_react_app_analytics_mocked   = "false"
    prod_react_app_mixpanel_token     = "1d1b09b008638080ab34fe9b75db84fd"
    prod_react_app_onetrust_domain_id = "084d5de2-d423-458a-9b28-0f8db3e55e71"
  }
  # deploy secrets
  pagopa-selfcare-frontend-variables_secret_deploy = {
  }
}

module "pagopa-selfcare-frontend_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.2.0"
  count  = var.pagopa-selfcare-frontend.pipeline.enable_code_review == true ? 1 : 0

  project_id = data.azuredevops_project.project.id
  repository = var.pagopa-selfcare-frontend.repository
  # github_service_connection_id = data.azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-selc-backoffice-frontend"

  variables = merge(
    local.pagopa-selfcare-frontend-variables,
    local.pagopa-selfcare-frontend-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-selfcare-frontend-variables_secret,
    local.pagopa-selfcare-frontend-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-selfcare-frontend_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-selfcare-frontend.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-selfcare-frontend.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-selc-backoffice-fe"

  variables = merge(
    local.pagopa-selfcare-frontend-variables,
    local.pagopa-selfcare-frontend-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-selfcare-frontend-variables_secret,
    local.pagopa-selfcare-frontend-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    #     data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
  ]
}
