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
    git_mail                = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username            = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection       = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name

    blob_container_name                    = "$web"
    # apim_basepath_selc_marketplace_be      = "selc-marketplace/api"

    dev_selc_api_host                      = "https://api.dev.platform.pagopa.it"
    dev_endpoint_azure                     = "pagopa-d-selc-checkout-cdn-endpoint"
    dev_profile_name_cdn_azure             = "pagopa-d-selc-checkout-cdn-profile"
    dev_storage_account_name               = "pagopadselccheckoutsa"
    dev_resource_group_azure               = "pagopa-d-selc-rg"
    
    #from gitops//selfcare
    dev_azure_subscription                 = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    dev_mixpanel_token                     = "6e1290bdda5885981a2f443f37444f0f"
    dev_onetrust_domain_id                 = "a8f58d7a-7f6a-4fe6-ac02-f95bac3876d4-test"
    
#     uat_azure_subscription  = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
#     prod_azure_subscription = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
  }
  # deploy secrets
  pagopa-selfcare-frontend-variables_secret_deploy = {
  }
}

module "pagopa-selfcare-frontend_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.2.0"
  count  = var.pagopa-selfcare-frontend.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-selfcare-frontend.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
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
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-selfcare-frontend_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-selfcare-frontend.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-selfcare-frontend.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id
#   path                         = "${local.domain}\\pagopa-selc-backoffice-frontend"


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
#     data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
#     data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
  ]
}
