variable "pagopa-platform-authorizer-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-platform-authorizer"
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
        project_key        = "pagopa_pagopa-platform-authorizer"
        project_name       = "pagopa-platform-authorizer"
      }
    }
  }
}

locals {
  # global vars
  pagopa-platform-authorizer-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-platform-authorizer-service.repository.branch_name
  }
  # global secrets
  pagopa-platform-authorizer-service-variables_secret = {
  }

  ## Code Review Pipeline  vars and secrets ##

  # code_review vars
  pagopa-platform-authorizer-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-platform-authorizer-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-platform-authorizer-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-platform-authorizer-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-platform-authorizer-service.pipeline.sonarcloud.project_name

    dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev.id
  }
  # code_review secrets
  pagopa-platform-authorizer-service-variables_secret_code_review = {
  }

  ## Deploy Pipeline vars and secrets ##

  # deploy vars
  pagopa-platform-authorizer-service-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name

    # acr section
    image_repository_name                = replace(var.pagopa-platform-authorizer-service.repository.name, "-", "")
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev.id
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat.id
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    dev_web_app_name  = "pagopa-d-weu"
    uat_web_app_name  = "pagopa-u-weu"
    prod_web_app_name = "pagopa-p-weu"

    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

    TF_APPINSIGHTS_SERVICE_CONN_PROD = module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_PROD  = data.azurerm_application_insights.application_insights_prod.id
  }

  # deploy secrets
  pagopa-platform-authorizer-service-variables_secret_deploy = {
    # secrets - dev environment
    DEV_AUTH_COSMOS_URI                 = module.shared_dev_secrets.values["auth-d-cosmos-uri"].value
    DEV_AUTH_COSMOS_KEY                 = module.shared_dev_secrets.values["auth-d-cosmos-key"].value
    DEV_INTEGRTEST_EXT_SUBSCRIPTION_KEY = module.shared_dev_secrets.values["auth-d-integrationtest-external-subkey"].value
    DEV_INTEGRTEST_VALID_SUBKEY         = module.shared_dev_secrets.values["auth-d-integrationtest-valid-subkey"].value
    DEV_INTEGRTEST_INVALID_SUBKEY       = module.shared_dev_secrets.values["auth-d-integrationtest-invalid-subkey"].value

    # secrets - uat environment
    UAT_AUTH_COSMOS_URI                 = module.shared_uat_secrets.values["auth-u-cosmos-uri"].value
    UAT_AUTH_COSMOS_KEY                 = module.shared_uat_secrets.values["auth-u-cosmos-key"].value
    UAT_INTEGRTEST_EXT_SUBSCRIPTION_KEY = module.shared_uat_secrets.values["auth-u-integrationtest-external-subkey"].value
    UAT_INTEGRTEST_VALID_SUBKEY         = module.shared_uat_secrets.values["auth-u-integrationtest-valid-subkey"].value
    UAT_INTEGRTEST_INVALID_SUBKEY       = module.shared_uat_secrets.values["auth-u-integrationtest-invalid-subkey"].value
  }
}

module "pagopa-platform-authorizer-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.2.1"
  count  = var.pagopa-platform-authorizer-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-platform-authorizer-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-platform-authorizer-service"


  variables = merge(
    local.pagopa-platform-authorizer-service-variables,
    local.pagopa-platform-authorizer-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-platform-authorizer-service-variables_secret,
    local.pagopa-platform-authorizer-service-variables_secret_code_review
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-platform-authorizer-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-platform-authorizer-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-platform-authorizer-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-platform-authorizer-service"

  variables = merge(
    local.pagopa-platform-authorizer-service-variables,
    local.pagopa-platform-authorizer-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-platform-authorizer-service-variables_secret,
    local.pagopa-platform-authorizer-service-variables_secret_deploy,
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
