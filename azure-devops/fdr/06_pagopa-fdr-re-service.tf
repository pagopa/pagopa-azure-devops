variable "pagopa-fdr-re-to-datastore" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-fdr-re-to-datastore"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = false
      enable_deploy      = true
      sonarcloud = {
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-fdr-re-to-datastore"
        project_name       = "pagopa-fdr-re-to-datastore"
      }
    }
  }
}

locals {
  pagopa-fdr-re-to-datastore-variables = {
    default_branch = var.pagopa-fdr-re-to-datastore.repository.branch_name
  }
  pagopa-fdr-re-to-datastore-variables_secret = {

  }
  pagopa-fdr-re-to-datastore-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-fdr-re-to-datastore.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-fdr-re-to-datastore.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-fdr-re-to-datastore.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-fdr-re-to-datastore.pipeline.sonarcloud.project_name
    # nodo4 variables of cd pipeline
  }
  pagopa-fdr-re-to-datastore-variables_secret_code_review = {
  }

  pagopa-fdr-re-to-datastore-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name

    image_repository_name                = replace(var.pagopa-fdr-re-to-datastore.repository.name, "-", "")
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

    #    TF_APPINSIGHTS_SERVICE_CONN_PROD = module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    #    TF_APPINSIGHTS_RESOURCE_ID_PROD  = data.azurerm_application_insights.application_insights_prod.id
  }

  # deploy secrets
  pagopa-fdr-re-to-datastore-variables_secret_deploy = {

  }
}

module "pagopa-fdr-re-to-datastore_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.2.1"
  count  = var.pagopa-fdr-re-to-datastore.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-fdr-re-to-datastore.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-fdr-re-to-datastore-service"

  pull_request_trigger_use_yaml = true
  ci_trigger_use_yaml           = true

  variables = merge(
    local.pagopa-fdr-re-to-datastore-variables,
    local.pagopa-fdr-re-to-datastore-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-fdr-re-to-datastore-variables_secret,
    local.pagopa-fdr-re-to-datastore-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}
module "pagopa-fdr-re-to-datastore_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-fdr-re-to-datastore.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-fdr-re-to-datastore.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-fdr-re-to-datastore-service"

  variables = merge(
    local.pagopa-fdr-re-to-datastore-variables,
    local.pagopa-fdr-re-to-datastore-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-fdr-re-to-datastore-variables_secret,
    local.pagopa-fdr-re-to-datastore-variables_secret_deploy,
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
    #    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
