variable "pagopa-nodo-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-nodo4-nodo-dei-pagamenti"
      branch_name     = "refs/heads/develop"
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
        project_key        = "pagopa_pagopa-nodo4-nodo-dei-pagamenti"
        project_name       = "pagopa-nodo4-nodo-dei-pagamenti"
      }
      integration_test = {
        enabled               = true
        name                  = "integration-test-pipeline"
        pipeline_yml_filename = "integration-test-pipelines.yml"
      }
      performance_test = {
        enabled               = true
        name                  = "performance-test-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-nodo-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-nodo-service.repository.branch_name
  }
  # global secrets
  pagopa-nodo-service-variables_secret = {

  }
  # code_review vars
  pagopa-nodo-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-nodo-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-nodo-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-nodo-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-nodo-service.pipeline.sonarcloud.project_name
    # nodo4 variables of cd pipeline
  }
  # code_review secrets
  pagopa-nodo-service-variables_secret_code_review = {
    lightbend_key_dev  = module.nodo_dev_secrets.values["lightbend-key"].value
    lightbend_key_uat  = module.nodo_uat_secrets.values["lightbend-key"].value
    lightbend_key_prod = module.nodo_prod_secrets.values["lightbend-key"].value
  }
  # deploy vars
  pagopa-nodo-service-variables_deploy = {
    git_email         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository_name                     = replace(var.pagopa-nodo-service.repository.name, "-", "")
    container-registry-service-connection-dev = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id
    repository                                = replace(var.pagopa-nodo-service.repository.name, "-", "")


    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id
    dev_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.service_endpoint_name
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id
    uat_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.service_endpoint_name
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.id
    prod_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.service_endpoint_name

    # aks section
    k8s_namespace                = "nodo"
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    azure_insights_enabled_dev  = true
    azure_insights_enabled_uat  = true
    azure_insights_enabled_prod = true

    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

    TF_APPINSIGHTS_SERVICE_CONN_PROD = module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_PROD  = data.azurerm_application_insights.application_insights_prod.id


    # nodo4 variables of cd pipeline
    deploy-pool-dev  = "pagopa-dev-linux"
    deploy-pool-uat  = "pagopa-uat-linux"
    deploy-pool-prod = "pagopa-prod-linux"
  }
  # deploy secrets
  pagopa-nodo-service-variables_secret_deploy = {
    lightbend_key_dev  = module.nodo_dev_secrets.values["lightbend-key"].value
    lightbend_key_uat  = module.nodo_uat_secrets.values["lightbend-key"].value
    lightbend_key_prod = module.nodo_prod_secrets.values["lightbend-key"].value
  }

  # integration vars
  pagopa-nodo-service-variables_integration_test = {
    github_connection               = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tf_dev_azure_service_connection = "io-azure-devops-github-rw"
  }
  # integration secrets
  pagopa-nodo-service-variables_secret_integration_test = {
  }
  # performance vars
  pagopa-nodo-service-variables_performance_test = {
    github_connection               = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tf_dev_azure_service_connection = "io-azure-devops-github-rw"
  }
  # performance secrets
  pagopa-nodo-service-variables_secret_performance_test = {
  }

  # performance vars
  pagopa-nodo-service-variables_suspend_job = {
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    # aks section
    k8s_namespace                = "nodo-cron"
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

  }
  # performance secrets
  pagopa-nodo-service-variables_secret_suspend_job = {
  }

}

module "pagopa-nodo-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-nodo-service.pipeline.enable_code_review == true ? 1 : 0

  project_id = data.azuredevops_project.project.id
  repository = var.pagopa-nodo-service.repository
  # github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-nodo-service"

  pull_request_trigger_use_yaml = true
  ci_trigger_use_yaml           = true

  variables = merge(
    local.pagopa-nodo-service-variables,
    local.pagopa-nodo-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-nodo-service-variables_secret,
    local.pagopa-nodo-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}
module "pagopa-nodo-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-nodo-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-nodo-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-nodo-service"

  variables = merge(
    local.pagopa-nodo-service-variables,
    local.pagopa-nodo-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-nodo-service-variables_secret,
    local.pagopa-nodo-service-variables_secret_deploy,
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
module "pagopa-nodo-service_integration_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-nodo-service.pipeline.integration_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-nodo-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  # github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                  = "${local.domain}\\pagopa-nodo-service"
  pipeline_name         = var.pagopa-nodo-service.pipeline.integration_test.name
  pipeline_yml_filename = var.pagopa-nodo-service.pipeline.integration_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-nodo-service-variables,
    local.pagopa-nodo-service-variables_integration_test,
  )

  variables_secret = merge(
    local.pagopa-nodo-service-variables_secret,
    local.pagopa-nodo-service-variables_secret_integration_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
module "pagopa-nodo-service_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-nodo-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-nodo-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  # github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                  = "${local.domain}\\pagopa-nodo-service"
  pipeline_name         = var.pagopa-nodo-service.pipeline.performance_test.name
  pipeline_yml_filename = var.pagopa-nodo-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-nodo-service-variables,
    local.pagopa-nodo-service-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-nodo-service-variables_secret,
    local.pagopa-nodo-service-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
