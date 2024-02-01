variable "pagopa-spontaneous-payments" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-spontaneous-payments"
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
        project_key        = "pagopa_pagopa-spontaneous-payments"
        project_name       = "pagopa-spontaneous-payments"
      }
    }
  }
}

locals {
  # global vars
  pagopa-spontaneous-payments-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-spontaneous-payments.repository.branch_name
  }
  # global secrets
  pagopa-spontaneous-payments-variables_secret = {

  }
  # code_review vars
  pagopa-spontaneous-payments-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-spontaneous-payments.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-spontaneous-payments.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-spontaneous-payments.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-spontaneous-payments.pipeline.sonarcloud.project_name

    dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev.id

  }
  # code_review secrets
  pagopa-spontaneous-payments-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-spontaneous-payments-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository_name                = replace(var.pagopa-spontaneous-payments.repository.name, "-", "")
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev.id
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat.id
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod.id

    # aks section
    k8s_namespace                = "gps"
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id


    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

    TF_APPINSIGHTS_SERVICE_CONN_PROD = module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_PROD  = data.azurerm_application_insights.application_insights_prod.id

  }
  # deploy secrets
  pagopa-spontaneous-payments-variables_secret_deploy = {

  }
}

module "pagopa-spontaneous-payments_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-spontaneous-payments.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-spontaneous-payments.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-spontaneous-payments-service"


  variables = merge(
    local.pagopa-spontaneous-payments-variables,
    local.pagopa-spontaneous-payments-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-spontaneous-payments-variables_secret,
    local.pagopa-spontaneous-payments-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-spontaneous-payments_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-spontaneous-payments.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-spontaneous-payments.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-spontaneous-payments-service"

  variables = merge(
    local.pagopa-spontaneous-payments-variables,
    local.pagopa-spontaneous-payments-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-spontaneous-payments-variables_secret,
    local.pagopa-spontaneous-payments-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev.id,
    data.azuredevops_serviceendpoint_azurecr.uat.id,
    data.azuredevops_serviceendpoint_azurecr.prod.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
