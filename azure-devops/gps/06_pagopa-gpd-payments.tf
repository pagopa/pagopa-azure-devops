variable "pagopa-gpd-payments" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-gpd-payments"
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
        project_key        = "pagopa_pagopa-gpd-payments"
        project_name       = "pagopa-gpd-payments"
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
  pagopa-gpd-payments-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-gpd-payments.repository.branch_name
  }
  # global secrets
  pagopa-gpd-payments-variables_secret = {
    DEV_API_CONFIG_SUBSCRIPTION_KEY    = module.gps_dev_secrets.values["gpd-d-apiconfig-subscription-key"].value
    DEV_GPD_SUBSCRIPTION_KEY           = module.gps_dev_secrets.values["gpd-d-gpd-subscription-key"].value
    DEV_GPS_SUBSCRIPTION_KEY           = module.gps_dev_secrets.values["gpd-d-gps-subscription-key"].value
    DEV_DONATIONS_SUBSCRIPTION_KEY     = module.gps_dev_secrets.values["gpd-d-donations-subscription-key"].value
    DEV_IUV_GENERATOR_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-d-iuv-generator-subscription-key"].value
    DEV_PAYMENTS_REST_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-d-payments-rest-subscription-key"].value
    DEV_PAYMENTS_SOAP_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-d-payments-soap-subscription-key"].value
    #####
    UAT_API_CONFIG_SUBSCRIPTION_KEY    = module.gps_uat_secrets.values["gpd-u-apiconfig-subscription-key"].value
    UAT_GPD_SUBSCRIPTION_KEY           = module.gps_uat_secrets.values["gpd-u-gpd-subscription-key"].value
    UAT_GPS_SUBSCRIPTION_KEY           = module.gps_uat_secrets.values["gpd-u-gps-subscription-key"].value
    UAT_DONATIONS_SUBSCRIPTION_KEY     = module.gps_uat_secrets.values["gpd-u-donations-subscription-key"].value
    UAT_IUV_GENERATOR_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-u-iuv-generator-subscription-key"].value
    UAT_PAYMENTS_REST_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-u-payments-rest-subscription-key"].value
    UAT_PAYMENTS_SOAP_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-u-payments-soap-subscription-key"].value
  }

  ## Code Review Pipeline  vars and secrets ##

  # code_review vars
  pagopa-gpd-payments-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-gpd-payments.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-gpd-payments.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-gpd-payments.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-gpd-payments.pipeline.sonarcloud.project_name

    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id

  }
  # code_review secrets
  pagopa-gpd-payments-variables_secret_code_review = {
  }

  ## Deploy Pipeline vars and secrets ##

  # deploy vars
  pagopa-gpd-payments-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository_name                = replace(var.pagopa-gpd-payments.repository.name, "-", "")
    dev_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

    # aks section
    k8s_namespace                = "gps"
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id


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
  pagopa-gpd-payments-variables_secret_deploy = {
  }

  ## Performance Test Pipeline vars and secrets ##

  # performance vars
  pagopa-gpd-payments-variables_performance_test = {
  }
  # performance secrets
  pagopa-gpd-payments-variables_secret_performance_test = {
  }
}

module "pagopa-gpd-payments_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.5"
  count  = var.pagopa-gpd-payments.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-payments.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-gpd-payments-service"


  variables = merge(
    local.pagopa-gpd-payments-variables,
    local.pagopa-gpd-payments-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-gpd-payments-variables_secret,
    local.pagopa-gpd-payments-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-gpd-payments_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.5"
  count  = var.pagopa-gpd-payments.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-payments.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-gpd-payments-service"

  variables = merge(
    local.pagopa-gpd-payments-variables,
    local.pagopa-gpd-payments-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-gpd-payments-variables_secret,
    local.pagopa-gpd-payments-variables_secret_deploy,
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

module "pagopa-gpd-payments_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.1.5"
  count  = var.pagopa-gpd-payments.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-payments.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  path                         = "${local.domain}\\pagopa-gpd-payments-service"
  pipeline_name                = var.pagopa-gpd-payments.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-gpd-payments.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-gpd-payments-variables,
    local.pagopa-gpd-payments-variables_performance_test
  )

  variables_secret = merge(
    local.pagopa-gpd-payments-variables_secret,
    local.pagopa-gpd-payments-variables_secret_performance_test
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}
