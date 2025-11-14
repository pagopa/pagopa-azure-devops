variable "pagopa-accounting-reconciliation-bdi-ingestion" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-accounting-reconciliation-bdi-ingestion"
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
        project_key        = "pagopa_pagopa-accounting-reconciliation-bdi-ingestion"
        project_name       = "pagopa-accounting-reconciliation-bdi-ingestion"
      }
    }
  }
}

locals {
  # global vars
  pagopa-accounting-reconciliation-bdi-ingestion-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-accounting-reconciliation-bdi-ingestion.repository.branch_name
  }
  # global secrets
  pagopa-accounting-reconciliation-bdi-ingestion-variables_secret = {

  }
  # code_review vars
  pagopa-accounting-reconciliation-bdi-ingestion-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-accounting-reconciliation-bdi-ingestion.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-accounting-reconciliation-bdi-ingestion.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-accounting-reconciliation-bdi-ingestion.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-accounting-reconciliation-bdi-ingestion.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-accounting-reconciliation-bdi-ingestion-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-accounting-reconciliation-bdi-ingestion-variables_deploy = {
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    # acr section
    k8s_image_repository_name            = replace(var.pagopa-accounting-reconciliation-bdi-ingestion.repository.name, "-", "")
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id
    dev_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.service_endpoint_name
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id
    uat_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.service_endpoint_name
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.id
    prod_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.service_endpoint_name

    # aks section
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-accounting-reconciliation-bdi-ingestion-variables_secret_deploy = {
    git_mail     = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
    tenant_id    = data.azurerm_client_config.current.tenant_id
  }
}

module "pagopa-accounting-reconciliation-bdi-ingestion_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-accounting-reconciliation-bdi-ingestion.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-accounting-reconciliation-bdi-ingestion.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-accounting-reconciliation-bdi-ingestion"
  ci_trigger_use_yaml          = true

  variables = merge(
    local.pagopa-accounting-reconciliation-bdi-ingestion-variables,
    local.pagopa-accounting-reconciliation-bdi-ingestion-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-accounting-reconciliation-bdi-ingestion-variables_secret,
    local.pagopa-accounting-reconciliation-bdi-ingestion-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-accounting-reconciliation-bdi-ingestion_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-accounting-reconciliation-bdi-ingestion.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-accounting-reconciliation-bdi-ingestion.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-accounting-reconciliation-bdi-ingestion"

  variables = merge(
    local.pagopa-accounting-reconciliation-bdi-ingestion-variables,
    local.pagopa-accounting-reconciliation-bdi-ingestion-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-accounting-reconciliation-bdi-ingestion-variables_secret,
    local.pagopa-accounting-reconciliation-bdi-ingestion-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
