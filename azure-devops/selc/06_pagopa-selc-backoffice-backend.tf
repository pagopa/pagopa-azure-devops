variable "pagopa-selc-backoffice-backend" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-selfcare-ms-backoffice-backend"
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
        project_key        = "pagopa_pagopa-selfcare-ms-backoffice-backend"
        project_name       = "pagopa-selfcare-ms-backoffice-backend"
      }
    }
  }
}

locals {
  # global vars
  pagopa-selc-backoffice-backend-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-selc-backoffice-backend.repository.branch_name    
  }
  
  # global secrets
  pagopa-selc-backoffice-backend-variables_secret = {

  }
  
  # code_review vars
  pagopa-selc-backoffice-backend-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-selc-backoffice-backend.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-selc-backoffice-backend.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-selc-backoffice-backend.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-selc-backoffice-backend.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-selc-backoffice-backend-variables_secret_code_review = {
  }
  
  # deploy vars
  pagopa-selc-backoffice-backend-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    image_repository_name = replace(var.pagopa-selc-backoffice-backend.repository.name, "-", "")
    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

    # custom section
    dev_azure_client_secret         = module.secrets.values["DEV_AZURE_CLIENT_SECRET"].value
    dev_azure_client_id             = module.secrets.values["DEV_AZURE_CLIENT_ID"].value
    dev_selc_apim_external_api_key  = module.secrets.values["DEV_SELC_APIM_EXTERNAL_API_KEY"].value

    uat_azure_client_secret         = module.secrets.values["UAT_AZURE_CLIENT_SECRET"].value
    uat_azure_client_id             = module.secrets.values["UAT_AZURE_CLIENT_ID"].value
    uat_selc_apim_external_api_key  = module.secrets.values["UAT_SELC_APIM_EXTERNAL_API_KEY"].value

    prod_azure_client_secret        = module.secrets.values["PROD_AZURE_CLIENT_SECRET"].value
    prod_azure_client_id            = module.secrets.values["PROD_AZURE_CLIENT_ID"].value
    prod_selc_apim_external_api_key = module.secrets.values["PROD_SELC_APIM_EXTERNAL_API_KEY"].value

    # aks section
    k8s_namespace                = "selc"
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    # apim
    dev_external_api_service_url = "https://api.dev.selfcare.pagopa.it"
    dev_azure_resource_group     = "pagopa-d-api-rg"
    dev_azure_service_name       = "pagopa-d-apim"

    uat_external_api_service_url = "https://api.uat.selfcare.pagopa.it"
    uat_azure_resource_group     = "pagopa-u-api-rg"
    uat_azure_service_name       = "pagopa-u-apim"

    prod_external_api_service_url = "https://api.selfcare.pagopa.it"
    prod_azure_resource_group     = "pagopa-p-api-rg"
    prod_azure_service_name       = "pagopa-p-apim"
  }
  
  # deploy secrets
  pagopa-selc-backoffice-backend-variables_secret_deploy = {

  }
}

module "pagopa-selc-backoffice-backend_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-selc-backoffice-backend.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-selc-backoffice-backend.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-selc-backoffice-backend"

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.pagopa-selc-backoffice-backend-variables,
    local.pagopa-selc-backoffice-backend-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-selc-backoffice-backend-variables_secret,
    local.pagopa-selc-backoffice-backend-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-selc-backoffice-backend_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-selc-backoffice-backend.pipeline.enable_deploy == true ? 1 : 0
  
  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-selc-backoffice-backend.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-selc-backoffice-backend"

  variables = merge(
    local.pagopa-selc-backoffice-backend-variables,
    local.pagopa-selc-backoffice-backend-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-selc-backoffice-backend-variables_secret,
    local.pagopa-selc-backoffice-backend-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
  ]
}
