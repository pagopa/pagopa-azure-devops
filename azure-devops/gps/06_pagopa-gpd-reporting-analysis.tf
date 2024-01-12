variable "pagopa-gpd-reporting-analysis" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-gpd-reporting-analysis"
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
        project_key        = "pagopa_pagopa-gpd-reporting-analysis"
        project_name       = "pagopa-gpd-reporting-analysis"
      }
    }
  }
}

locals {
  # global vars
  pagopa-gpd-reporting-analysis-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-gpd-reporting-analysis.repository.branch_name
  }
  # global secrets
  pagopa-gpd-reporting-analysis-variables_secret = {
  }

  ## Code Review Pipeline  vars and secrets ##

  # code_review vars
  pagopa-gpd-reporting-analysis-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-gpd-reporting-analysis.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-gpd-reporting-analysis.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-gpd-reporting-analysis.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-gpd-reporting-analysis.pipeline.sonarcloud.project_name

    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
  }
  # code_review secrets
  pagopa-gpd-reporting-analysis-variables_secret_code_review = {
  }

  ## Deploy Pipeline vars and secrets ##

  # deploy vars
  pagopa-gpd-reporting-analysis-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    dev_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name

    # acr section
    image_repository_name                = replace(var.pagopa-gpd-reporting-analysis.repository.name, "-", "")
    dev_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

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
  pagopa-gpd-reporting-analysis-variables_secret_deploy = {
    # integration test secrets - dev environment
    DEV_API_CONFIG_SUBSCRIPTION_KEY       = module.gps_dev_secrets.values["gpd-d-apiconfig-subscription-key"].value
    DEV_GPD_SUBSCRIPTION_KEY              = module.gps_dev_secrets.values["gpd-d-gpd-subscription-key"].value
    DEV_PAYMENTS_REST_SUBSCRIPTION_KEY    = module.gps_dev_secrets.values["gpd-d-payments-rest-subscription-key"].value
    DEV_PAYMENTS_SOAP_SUBSCRIPTION_KEY    = module.gps_dev_secrets.values["gpd-d-payments-soap-subscription-key"].value
    DEV_REPORTING_SUBSCRIPTION_KEY        = module.gps_dev_secrets.values["gpd-d-reporting-subscription-key"].value
    DEV_REPORTING_BATCH_CONNECTION_STRING = module.gps_dev_secrets.values["gpd-d-reporting-batch-connection-string"].value

    # integration test secrets - uat environment
    UAT_API_CONFIG_SUBSCRIPTION_KEY       = module.gps_uat_secrets.values["gpd-u-apiconfig-subscription-key"].value
    UAT_GPD_SUBSCRIPTION_KEY              = module.gps_uat_secrets.values["gpd-u-gpd-subscription-key"].value
    UAT_PAYMENTS_REST_SUBSCRIPTION_KEY    = module.gps_uat_secrets.values["gpd-u-payments-rest-subscription-key"].value
    UAT_PAYMENTS_SOAP_SUBSCRIPTION_KEY    = module.gps_uat_secrets.values["gpd-u-payments-soap-subscription-key"].value
    UAT_REPORTING_SUBSCRIPTION_KEY        = module.gps_uat_secrets.values["gpd-u-reporting-subscription-key"].value
    UAT_REPORTING_BATCH_CONNECTION_STRING = module.gps_uat_secrets.values["gpd-u-reporting-batch-connection-string"].value
  }
}

module "pagopa-gpd-reporting-analysis_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.5"
  count  = var.pagopa-gpd-reporting-analysis.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-reporting-analysis.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-gpd-reporting-analysis-service"


  variables = merge(
    local.pagopa-gpd-reporting-analysis-variables,
    local.pagopa-gpd-reporting-analysis-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-gpd-reporting-analysis-variables_secret,
    local.pagopa-gpd-reporting-analysis-variables_secret_code_review
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-gpd-reporting-analysis_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.5"
  count  = var.pagopa-gpd-reporting-analysis.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-reporting-analysis.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-gpd-reporting-analysis-service"

  variables = merge(
    local.pagopa-gpd-reporting-analysis-variables,
    local.pagopa-gpd-reporting-analysis-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-gpd-reporting-analysis-variables_secret,
    local.pagopa-gpd-reporting-analysis-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
