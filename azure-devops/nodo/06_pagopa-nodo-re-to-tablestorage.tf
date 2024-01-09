variable "pagopa-nodo-re-to-tablestorage" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-nodo-re-to-tablestorage"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = false
      enable_deploy      = true
      sonarcloud = {
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-nodo-re-to-tablestorage"
        project_name       = "pagopa-nodo-re-to-tablestorage"
      }
    }
  }
}

locals {
  pagopa-nodo-re-to-tablestorage-variables = {
    default_branch = var.pagopa-nodo-service.repository.branch_name
  }
  pagopa-nodo-re-to-tablestorage-variables_secret = {

  }
  pagopa-nodo-re-to-tablestorage-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-nodo-re-to-tablestorage.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-nodo-re-to-tablestorage.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-nodo-re-to-tablestorage.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-nodo-re-to-tablestorage.pipeline.sonarcloud.project_name
  }
  pagopa-nodo-re-to-tablestorage-variables_secret_code_review = {

  }

  pagopa-nodo-re-to-tablestorage-variables_deploy = {
    dev_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name

    git_email         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name

    dev_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

    image_repository_name = replace(var.pagopa-nodo-re-to-tablestorage.repository.name, "-", "")

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"
  }
  pagopa-nodo-re-to-tablestorage-variables_secret_deploy = {

  }
}

module "pagopa-nodo-re-to-tablestorage_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.5"
  count  = var.pagopa-nodo-re-to-tablestorage.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-nodo-re-to-tablestorage.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-nodo-re-to-tablestorage-service"

  variables = merge(
    local.pagopa-nodo-re-to-tablestorage-variables,
    local.pagopa-nodo-re-to-tablestorage-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-nodo-re-to-tablestorage-variables_secret,
    local.pagopa-nodo-re-to-tablestorage-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
