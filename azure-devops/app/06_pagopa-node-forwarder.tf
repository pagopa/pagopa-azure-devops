variable "pagopa-node-forwarder" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-node-forwarder"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      performance_test = {
        enabled               = true
        name                  = "performance-test-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
      sonarcloud = {
        # TODO azure devops terraform provider does not support SonarCloud service endpoint
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-node-forwarder"
        project_name       = "pagopa-node-forwarder"
      }
    }
  }
}

locals {
  # global vars
  pagopa-node-forwarder-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-node-forwarder.repository.branch_name
  }
  # global secrets
  pagopa-node-forwarder-variables_secret = {

  }
  # code_review vars
  pagopa-node-forwarder-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-node-forwarder.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-node-forwarder.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-node-forwarder.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-node-forwarder.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-node-forwarder-variables_secret_code_review = {
    danger_github_api_token = "skip"

    dev_container_registry_service_conn = azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.service_endpoint_name
  }
  # deploy vars
  pagopa-node-forwarder-variables_deploy = {
    git_mail                        = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username                    = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection               = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    healthcheck_endpoint            = "/actuator/info"
    dev_deploy_type                 = "production_slot" #or staging_slot_and_swap
    dev_azure_subscription          = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    dev_web_app_name                = "pagopa-d-app-node-forwarder"
    dev_web_app_resource_group_name = "pagopa-d-node-forwarder-rg"

    uat_deploy_type                  = "production_slot" #or staging_slot_and_swap
    uat_azure_subscription           = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    uat_web_app_name                 = "pagopa-u-app-node-forwarder"
    uat_web_app_resource_group_name  = "pagopa-u-node-forwarder-rg"
    prod_deploy_type                 = "production_slot" #or staging_slot_and_swap
    prod_azure_subscription          = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
    prod_web_app_name                = "pagopa-p-app-node-forwarder"
    prod_web_app_resource_group_name = "pagopa-p-node-forwarder-rg"

    tenant_id = module.secrets.values["TENANTID"].value

    # acr section
    image_repository = "pagopanodeforwarder"

    dev_container_registry_service_conn  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.service_endpoint_name
    uat_container_registry_service_conn  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_uat.service_endpoint_name
    prod_container_registry_service_conn = azuredevops_serviceendpoint_azurecr.acr_docker_registry_prod.service_endpoint_name

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-node-forwarder-variables_secret_deploy = {

  }

  # performance vars
  pagopa-node-forwarder-variables_performance_test = {
    DEV_API_SUBSCRIPTION_KEY = module.pagopa-node-forwarder_dev_secrets.values["node-forwarder-api-subscription-key"].value
    UAT_API_SUBSCRIPTION_KEY = module.pagopa-node-forwarder_uat_secrets.values["node-forwarder-api-subscription-key"].value
  }
  # performance secrets
  pagopa-node-forwarder-variables_secret_performance_test = {
  }
}

module "pagopa-node-forwarder_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.4"
  count  = var.pagopa-node-forwarder.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-node-forwarder.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-node-forwarder-variables,
    local.pagopa-node-forwarder-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-node-forwarder-variables_secret,
    local.pagopa-node-forwarder-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-node-forwarder_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.4"
  count  = var.pagopa-node-forwarder.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-node-forwarder.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-node-forwarder-variables,
    local.pagopa-node-forwarder-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-node-forwarder-variables_secret,
    local.pagopa-node-forwarder-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}

module "pagopa-node-forwarder_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v2.6.3"
  count  = var.pagopa-node-forwarder.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-node-forwarder.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id
  path                         = var.pagopa-node-forwarder.repository.name
  pipeline_name                = var.pagopa-node-forwarder.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-node-forwarder.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-node-forwarder-variables,
    local.pagopa-node-forwarder-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-node-forwarder-variables_secret,
    local.pagopa-node-forwarder-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id
  ]
}
