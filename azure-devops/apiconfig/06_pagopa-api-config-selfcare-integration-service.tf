variable "pagopa-api-config-selfcare-integration-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-api-config-selfcare-integration"
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
        project_key        = "pagopa_pagopa-api-config-selfcare-integration"
        project_name       = "pagopa-api-config-selfcare-integration"
      }
      performance_test = {
        enabled               = true
        name                  = "performance-test-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yaml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-api-config-selfcare-integration-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-api-config-selfcare-integration-service.repository.branch_name
  }
  # global secrets
  pagopa-api-config-selfcare-integration-service-variables_secret = {

  }
  # code_review vars
  pagopa-api-config-selfcare-integration-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-api-config-selfcare-integration-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-api-config-selfcare-integration-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-api-config-selfcare-integration-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-api-config-selfcare-integration-service.pipeline.sonarcloud.project_name

    dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev.id

  }
  # code_review secrets
  pagopa-api-config-selfcare-integration-service-variables_secret_code_review = {
  }

  # deploy vars
  pagopa-api-config-selfcare-integration-service-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository_name                = replace(var.pagopa-api-config-selfcare-integration-service.repository.name, "-", "")
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev.id
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat.id
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod.id

    # aks section
    k8s_namespace               = "apiconfig"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    # uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    # prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

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
  pagopa-api-config-selfcare-integration-service-variables_secret_deploy = {

  }

  # performance vars
  pagopa-api-config-selfcare-integration-service-variables_performance_test = {
    DEV_API_SUBSCRIPTION_KEY = module.apiconfig_dev_secrets.values["apiconfig-selfcare-integration-api-subscription-key"].value
    UAT_API_SUBSCRIPTION_KEY = module.apiconfig_dev_secrets.values["apiconfig-selfcare-integration-api-subscription-key"].value
  }
  # performance secrets
  pagopa-api-config-selfcare-integration-service-variables_secret_performance_test = {
    #TODO
  }

}

module "pagopa-api-config-selfcare-integration-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-api-config-selfcare-integration-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-api-config-selfcare-integration-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-api-config-selfcare-integration-service"


  variables = merge(
    local.pagopa-api-config-selfcare-integration-service-variables,
    local.pagopa-api-config-selfcare-integration-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-api-config-selfcare-integration-service-variables_secret,
    local.pagopa-api-config-selfcare-integration-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-api-config-selfcare-integration-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-api-config-selfcare-integration-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-api-config-selfcare-integration-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-api-config-selfcare-integration-service"

  variables = merge(
    local.pagopa-api-config-selfcare-integration-service-variables,
    local.pagopa-api-config-selfcare-integration-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-api-config-selfcare-integration-service-variables_secret,
    local.pagopa-api-config-selfcare-integration-service-variables_secret_deploy,
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

module "pagopa-api-config-selfcare-integration-service_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-api-config-selfcare-integration-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-api-config-selfcare-integration-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-api-config-selfcare-integration-service"
  pipeline_name                = var.pagopa-api-config-selfcare-integration-service.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-api-config-selfcare-integration-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-api-config-selfcare-integration-service-variables,
    local.pagopa-api-config-selfcare-integration-service-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-api-config-selfcare-integration-service-variables_secret,
    local.pagopa-api-config-selfcare-integration-service-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
