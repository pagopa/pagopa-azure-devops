variable "pagopa-payment-wallet-scheduler-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-payment-wallet-scheduler-service"
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
        project_key        = "pagopa_pagopa-payment-wallet-scheduler-service"
        project_name       = "pagopa-payment-wallet-scheduler-service"
      }
    }
  }
}

locals {
  # global vars
  pagopa-payment-wallet-scheduler-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-payment-wallet-scheduler-service.repository.branch_name
  }
  # global secrets
  pagopa-payment-wallet-scheduler-service-variables_secret = {

  }
  # code_review vars
  pagopa-payment-wallet-scheduler-service-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-payment-wallet-scheduler-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-payment-wallet-scheduler-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-payment-wallet-scheduler-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-payment-wallet-scheduler-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-payment-wallet-scheduler-service-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-payment-wallet-scheduler-service-variables_deploy = {
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    # acr section
    k8s_image_repository_name           = replace(var.pagopa-payment-wallet-scheduler-service.repository.name, "-", "")
    dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.id
    dev_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.service_endpoint_name
    uat_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.id
    uat_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.service_endpoint_name
    # prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.id
    # prod_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.service_endpoint_name

    # aks section
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    # prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace = "pagopaditncoreacr.azurecr.io"
    uat_container_namespace = "pagopauitncoreacr.azurecr.io"
    # prod_container_namespace = "pagopapitncoreacr.azurecr.io"

  }
  # deploy secrets
  pagopa-payment-wallet-scheduler-service-variables_secret_deploy = {
    git_mail     = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
    tenant_id    = data.azurerm_client_config.current.tenant_id
  }
}

module "pagopa-payment-wallet-scheduler-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-payment-wallet-scheduler-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-payment-wallet-scheduler-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-payment-wallet-scheduler-service"

  variables = merge(
    local.pagopa-payment-wallet-scheduler-service-variables,
    local.pagopa-payment-wallet-scheduler-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-payment-wallet-scheduler-service-variables_secret,
    local.pagopa-payment-wallet-scheduler-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-payment-wallet-scheduler-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-payment-wallet-scheduler-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-payment-wallet-scheduler-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-payment-wallet-scheduler-service"

  variables = merge(
    local.pagopa-payment-wallet-scheduler-service-variables,
    local.pagopa-payment-wallet-scheduler-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-payment-wallet-scheduler-service-variables_secret,
    local.pagopa-payment-wallet-scheduler-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.id,
    # data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    # data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
