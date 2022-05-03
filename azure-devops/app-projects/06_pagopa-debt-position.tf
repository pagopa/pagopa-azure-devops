variable "pagopa-debt-position" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-debt-position"
      branch_name     = "main"
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
        project_key        = "pagopa_pagopa-debt-position"
        project_name       = "pagopa-debt-position"
      }
    }
  }
}

locals {
  # global vars
  pagopa-debt-position-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-debt-position.repository.branch_name
  }
  # global secrets
  pagopa-debt-position-variables_secret = {

  }
  # code_review vars
  pagopa-debt-position-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-debt-position.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-debt-position.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-debt-position.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-debt-position.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-debt-position-variables_secret_code_review = {
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-debt-position-variables_deploy = {
    git_mail                = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username            = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection       = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    healthcheck_endpoint    = "/api/v1/info"
    dev_azure_subscription  = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    dev_web_app_name        = "pagopa-d"
    uat_azure_subscription  = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    uat_web_app_name        = "pagopa-u"
    prod_azure_subscription = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
    prod_web_app_name       = "pagopa-p"

    tenant_id = module.secrets.values["TENANTID"].value

    # acr section
    image_repository = "debt-position"

    dev_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.service_endpoint_name
    uat_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_uat.service_endpoint_name
    prod_container_registry = azuredevops_serviceendpoint_azurecr.acr_docker_registry_prod.service_endpoint_name

    dev_container_namespace  = "pagopadacr.azurecr.io"
    uat_container_namespace  = "pagopauacr.azurecr.io"
    prod_container_namespace = "pagopapacr.azurecr.io"

    # datasource4flyway
    DEV_SPRING_DATASOURCE_USERNAME  = "apduser@pagopa-d-postgresql"
    UAT_SPRING_DATASOURCE_USERNAME  = "apduser"
    PROD_SPRING_DATASOURCE_USERNAME = "apduser"
    DEV_SPRING_DATASOURCE_PASSWORD  = module.secrets.values["DEV-APD-SPRING-DATASOURCE-PWD"].value
    UAT_SPRING_DATASOURCE_PASSWORD  = module.secrets.values["UAT-APD-SPRING-DATASOURCE-PWD"].value
    PRPD_SPRING_DATASOURCE_PASSWORD = module.secrets.values["PROD-APD-SPRING-DATASOURCE-PWD"].value
    DEV_SPRING_DATASOURCE_URL       = format("jdbc:postgresql://%s:5432/%s", "pagopa-d-postgresql.postgres.database.azure.com", "apd")
    UAT_SPRING_DATASOURCE_URL       = format("jdbc:postgresql://%s:5432/%s?sslmode=require&prepareThreshold=0", "pagopa-u-gpd-pgflex.postgres.database.azure.com", "apd")
    PROD_SPRING_DATASOURCE_URL      = format("jdbc:postgresql://%s:5432/%s?sslmode=require&prepareThreshold=0", "pagopa-p-gpd-pgflex.postgres.database.azure.com", "apd")
    SCHEMA_NAME                     = "apd"

  }
  # deploy secrets
  pagopa-debt-position-variables_secret_deploy = {

  }
}

module "pagopa-debt-position_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-debt-position.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-debt-position.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-debt-position-variables,
    local.pagopa-debt-position-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-debt-position-variables_secret,
    local.pagopa-debt-position-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-debt-position_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-debt-position.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-debt-position.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-debt-position-variables,
    local.pagopa-debt-position-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-debt-position-variables_secret,
    local.pagopa-debt-position-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
