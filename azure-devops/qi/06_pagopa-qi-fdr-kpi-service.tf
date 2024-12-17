variable "pagopa-qi-fdr-kpi-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-qi-fdr-kpi-service"
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
        project_key        = "pagopa_pagopa-qi-fdr-kpi-service"
        project_name       = "pagopa-qi-fdr-kpi-service"
      }
    }
  }
}

locals {
  # global vars
  pagopa-qi-fdr-kpi-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-qi-fdr-kpi-service.repository.branch_name
  }
  # global secrets
  pagopa-qi-fdr-kpi-service-variables_secret = {

  }
  # code_review vars
  pagopa-qi-fdr-kpi-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-qi-fdr-kpi-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-qi-fdr-kpi-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-qi-fdr-kpi-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-qi-fdr-kpi-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-qi-fdr-kpi-service-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-qi-fdr-kpi-service-variables_deploy = {
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    # acr section
    k8s_image_repository_name            = replace(var.pagopa-qi-fdr-kpi-service.repository.name, "-", "")
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
  pagopa-qi-fdr-kpi-service-variables_secret_deploy = {
    git_mail     = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
    tenant_id    = data.azurerm_client_config.current.tenant_id
  }
}

module "pagopa-qi-fdr-kpi-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-qi-fdr-kpi-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-qi-fdr-kpi-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-qi-fdr-kpi-service"

  variables = merge(
    local.pagopa-qi-fdr-kpi-service-variables,
    local.pagopa-qi-fdr-kpi-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-qi-fdr-kpi-service-variables_secret,
    local.pagopa-qi-fdr-kpi-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    local.azuredevops_serviceendpoint_sonarcloud_id,
    data.azuredevops_serviceendpoint_github.github_ro.service_endpoint_id
  ]
}


module "pagopa-qi-fdr-kpi-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-qi-fdr-kpi-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-qi-fdr-kpi-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-qi-fdr-kpi-service"

  variables = merge(
    local.pagopa-qi-fdr-kpi-service-variables,
    local.pagopa-qi-fdr-kpi-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-qi-fdr-kpi-service-variables_secret,
    local.pagopa-qi-fdr-kpi-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
  ]
}
