variable "pagopa-gpd-reporting-batch" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-gpd-reporting-batch"
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
        project_key        = "pagopa_pagopa-gpd-reporting-batch"
        project_name       = "pagopa-gpd-reporting-batch"
      }
    }
  }
}

locals {
  # global vars
  pagopa-gpd-reporting-batch-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-gpd-reporting-batch.repository.branch_name
  }
  # global secrets
  pagopa-gpd-reporting-batch-variables_secret = {
  }

  ## Code Review Pipeline  vars and secrets ##

  # code_review vars
  pagopa-gpd-reporting-batch-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-gpd-reporting-batch.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-gpd-reporting-batch.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-gpd-reporting-batch.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-gpd-reporting-batch.pipeline.sonarcloud.project_name

    dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev.id
  }
  # code_review secrets
  pagopa-gpd-reporting-batch-variables_secret_code_review = {
  }

  ## Deploy Pipeline vars and secrets ##

  # deploy vars
  pagopa-gpd-reporting-batch-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name

    # acr section
    image_repository_name                = replace(var.pagopa-gpd-reporting-batch.repository.name, "-", "")
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
}

module "pagopa-gpd-reporting-batch_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-gpd-reporting-batch.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-reporting-batch.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-gpd-reporting-batch-service"


  variables = merge(
    local.pagopa-gpd-reporting-batch-variables,
    local.pagopa-gpd-reporting-batch-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-gpd-reporting-batch-variables_secret,
    local.pagopa-gpd-reporting-batch-variables_secret_code_review
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}
