variable "pagopa-nodo-re-to-datastore" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-nodo-re-to-datastore"
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
        project_key        = "pagopa_pagopa-nodo-re-to-datastore"
        project_name       = "pagopa-nodo-re-to-datastore"
      }
    }
  }
}

locals {
  pagopa-nodo-re-to-datastore-variables = {
    default_branch = var.pagopa-nodo-service.repository.branch_name
  }
  pagopa-nodo-re-to-datastore-variables_secret = {

  }
  pagopa-nodo-re-to-datastore-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-nodo-re-to-datastore.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-nodo-re-to-datastore.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-nodo-re-to-datastore.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-nodo-re-to-datastore.pipeline.sonarcloud.project_name
  }
  pagopa-nodo-re-to-datastore-variables_secret_code_review = {

  }

  pagopa-nodo-re-to-datastore-variables_deploy = {
    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name

    git_email         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name


    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id
    dev_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.service_endpoint_name
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id
    uat_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.service_endpoint_name
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.id
    prod_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.service_endpoint_name

    image_repository_name = replace(var.pagopa-nodo-re-to-datastore.repository.name, "-", "")

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"
  }
  pagopa-nodo-re-to-datastore-variables_secret_deploy = {

  }
}

module "pagopa-nodo-re-to-datastore_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-nodo-re-to-datastore.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-nodo-re-to-datastore.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-nodo-re-to-datastore-service"

  variables = merge(
    local.pagopa-nodo-re-to-datastore-variables,
    local.pagopa-nodo-re-to-datastore-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-nodo-re-to-datastore-variables_secret,
    local.pagopa-nodo-re-to-datastore-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
