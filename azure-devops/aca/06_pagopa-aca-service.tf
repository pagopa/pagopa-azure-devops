variable "pagopa-aca-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-aca-service"
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
        project_key        = "pagopa_pagopa-aca-service"
        project_name       = "pagopa-aca-service"
      }
    }
  }
}

locals {
  # global vars
  pagopa-aca-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-aca-service.repository.branch_name
  }
  # global secrets
  pagopa-aca-service-variables_secret = {

  }
  # code_review vars
  pagopa-aca-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-aca-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-aca-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-aca-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-aca-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-aca-service-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-aca-service-variables_deploy = {
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name

    # acr section
    k8s_image_repository_name            = replace(var.pagopa-aca-service.repository.name, "-", "")
    dev_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    dev_container_registry_name          = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_name
    uat_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    uat_container_registry_name          = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_name
    prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id
    prod_container_registry_name         = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_name

    # aks section
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-aca-service-variables_secret_deploy = {
    git_mail        = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username    = module.secrets.values["azure-devops-github-USERNAME"].value
    tenant_id       = data.azurerm_client_config.current.tenant_id
    aca_api_key_dev = module.aca_dev_secrets.values["aca-api-key"].value
    aca_api_key_uat = module.aca_uat_secrets.values["aca-api-key"].value
  }
}

module "pagopa-aca-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.5"
  count  = var.pagopa-aca-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-aca-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-aca-service"

  variables = merge(
    local.pagopa-aca-service-variables,
    local.pagopa-aca-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-aca-service-variables_secret,
    local.pagopa-aca-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-aca-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.5"
  count  = var.pagopa-aca-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-aca-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-aca-service"

  variables = merge(
    local.pagopa-aca-service-variables,
    local.pagopa-aca-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-aca-service-variables_secret,
    local.pagopa-aca-service-variables_secret_deploy,
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

