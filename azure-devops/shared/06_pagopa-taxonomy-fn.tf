variable "pagopa-taxonomy" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-taxonomy"
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
        project_key        = "pagopa_pagopa-taxonomy"
        project_name       = "pagopa-taxonomy"
      }
    }
  }
}

locals {
  pagopa-taxonomy-variables = {
    default_branch = var.pagopa-taxonomy.repository.branch_name
  }
  pagopa-taxonomy-variables_secret = {

  }
  pagopa-taxonomy-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-taxonomy.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-taxonomy.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-taxonomy.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-taxonomy.pipeline.sonarcloud.project_name
  }
  pagopa-taxonomy-variables_secret_code_review = {
  }

  pagopa-taxonomy-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name

    image_repository_name                = replace(var.pagopa-taxonomy.repository.name, "-", "")
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
  pagopa-taxonomy-variables_secret_deploy = {

  }
}

module "pagopa-taxonomy_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-taxonomy.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-taxonomy.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-taxonomy"

  variables = merge(
    local.pagopa-taxonomy-variables,
    local.pagopa-taxonomy-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-taxonomy-variables_secret,
    local.pagopa-taxonomy-variables_secret_deploy,
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
