variable "pagopa-reporting-fdr" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-reporting-fdr"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pagopa"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      sonarcloud = {
        # TODO azure devops terraform provider does not support SonarCloud service endpoint
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-reporting-fdr"
        project_name       = "pagopa-reporting-fdr"
      }

    }
  }
}

locals {
  # global vars
  pagopa-reporting-fdr-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-reporting-fdr.repository.branch_name
  }
  # global secrets
  pagopa-reporting-fdr-variables_secret = {

  }
  # code_review vars
  pagopa-reporting-fdr-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-reporting-fdr.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-reporting-fdr.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-reporting-fdr.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-reporting-fdr.pipeline.sonarcloud.project_name
    danger_github_api_token = "skip"
  }
  # code_review secrets
  pagopa-reporting-fdr-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-reporting-fdr-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id = data.azurerm_client_config.current.tenant_id

    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name

    # acr section
    image_repository = "reporting-fdr"
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev.id
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat.id
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    healthcheck_endpoint             = "/api/v1/info"
    dev_deploy_type                  = "production_slot" #or staging_slot_and_swap
    dev_web_app_name                 = "pagopa-d-fn-reportingfdr"
    dev_web_app_resource_group_name  = "pagopa-d-reporting-fdr-rg"
    uat_deploy_type                  = "production_slot" #or staging_slot_and_swap
    uat_web_app_name                 = "pagopa-u-fn-reportingfdr"
    uat_web_app_resource_group_name  = "pagopa-u-reporting-fdr-rg"
    prod_deploy_type                 = "production_slot" #or staging_slot_and_swap
    prod_web_app_name                = "pagopa-p-fn-reportingfdr"
    prod_web_app_resource_group_name = "pagopa-p-reporting-fdr-rg"

    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

    TF_APPINSIGHTS_SERVICE_CONN_PROD = module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_PROD  = data.azurerm_application_insights.application_insights_prod.id

  }
  # deploy secrets
  pagopa-reporting-fdr-variables_secret_deploy = {

  }
}

module "pagopa-reporting-fdr_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-reporting-fdr.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-reporting-fdr.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\${var.pagopa-reporting-fdr.repository.name}"

  variables = merge(
    local.pagopa-reporting-fdr-variables,
    local.pagopa-reporting-fdr-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-reporting-fdr-variables_secret,
    local.pagopa-reporting-fdr-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-reporting-fdr_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-reporting-fdr.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-reporting-fdr.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\${var.pagopa-reporting-fdr.repository.name}"


  variables = merge(
    local.pagopa-reporting-fdr-variables,
    local.pagopa-reporting-fdr-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-reporting-fdr-variables_secret,
    local.pagopa-reporting-fdr-variables_secret_deploy,
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
