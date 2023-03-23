variable "pagopa-reporting-orgs-enrollment" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-reporting-orgs-enrollment"
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
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-reporting-orgs-enrollment"
        project_name       = "pagopa-reporting-orgs-enrollment"
      }
    }
  }
}

locals {
  # global vars
  pagopa-reporting-orgs-enrollment-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-reporting-orgs-enrollment.repository.branch_name
  }
  # global secrets
  pagopa-reporting-orgs-enrollment-variables_secret = {
  }
  # code_review vars
  pagopa-reporting-orgs-enrollment-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-reporting-orgs-enrollment.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-reporting-orgs-enrollment.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-reporting-orgs-enrollment.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-reporting-orgs-enrollment.pipeline.sonarcloud.project_name

    dev_container_registry = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id

  }
  # code_review secrets
  pagopa-reporting-orgs-enrollment-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-reporting-orgs-enrollment-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    image_repository        = replace(var.pagopa-reporting-orgs-enrollment.repository.name, "-", "")
    dev_container_registry  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    prod_container_registry = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

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
  pagopa-reporting-orgs-enrollment-variables_secret_deploy = {
    DEV_API_SUBSCRIPTION_KEY = module.afm_dev_secrets.values["gpd-d-reporting-enrollment-subscription-key"].value
    UAT_API_SUBSCRIPTION_KEY = module.afm_dev_secrets.values["gpd-u-reporting-enrollment-subscription-key"].value
  }
  # performance vars
  pagopa-afm-calculator-service-variables_performance_test = {
  }
  # performance secrets
  pagopa-afm-calculator-service-variables_secret_performance_test = {
    DEV_API_SUBSCRIPTION_KEY = module.afm_dev_secrets.values["gpd-d-reporting-enrollment-subscription-key"].value
    UAT_API_SUBSCRIPTION_KEY = module.afm_dev_secrets.values["gpd-u-reporting-enrollment-subscription-key"].value
  }
}

module "pagopa-reporting-orgs-enrollment_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.2.0"
  count  = var.pagopa-reporting-orgs-enrollment.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-reporting-orgs-enrollment.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-reporting-orgs-enrollment"

  variables = merge(
    local.pagopa-reporting-orgs-enrollment-variables,
    local.pagopa-reporting-orgs-enrollment-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-reporting-orgs-enrollment-variables_secret,
    local.pagopa-reporting-orgs-enrollment-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-reporting-orgs-enrollment_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-reporting-orgs-enrollment.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-reporting-orgs-enrollment.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-reporting-orgs-enrollment"

  variables = merge(
    local.pagopa-reporting-orgs-enrollment-variables,
    local.pagopa-reporting-orgs-enrollment-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-reporting-orgs-enrollment-variables_secret,
    local.pagopa-reporting-orgs-enrollment-variables_secret_deploy,
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

module "pagopa-reporting-orgs-enrollment_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v2.6.3"
  count  = var.pagopa-reporting-orgs-enrollment.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-reporting-orgs-enrollment.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  path                         = "${local.domain}\\pagopa-reporting-orgs-enrollment"
  pipeline_name                = var.pagopa-reporting-orgs-enrollment.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-reporting-orgs-enrollment.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-reporting-orgs-enrollment-variables,
    local.pagopa-reporting-orgs-enrollment_performance_test,
  )

  variables_secret = merge(
    local.pagopa-reporting-orgs-enrollment-variables_secret,
    local.pagopa-reporting-orgs-enrollment-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}
