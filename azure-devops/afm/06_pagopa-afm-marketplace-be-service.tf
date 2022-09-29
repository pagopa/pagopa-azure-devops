variable "pagopa-afm-marketplace-be-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-afm-marketplace-be"
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
        project_key        = "pagopa_pagopa-afm-marketplace-be"
        project_name       = "pagopa-afm-marketplace-be"
      }
    }
  }
}

locals {
  # global vars
  pagopa-afm-marketplace-be-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-afm-marketplace-be-service.repository.branch_name
  }
  # global secrets
  pagopa-afm-marketplace-be-service-variables_secret = {

  }
  # code_review vars
  pagopa-afm-marketplace-be-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-afm-marketplace-be-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-afm-marketplace-be-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-afm-marketplace-be-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-afm-marketplace-be-service.pipeline.sonarcloud.project_name

    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id

  }
  # code_review secrets
  pagopa-afm-marketplace-be-service-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-afm-marketplace-be-service-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    image_repository_name               = replace(var.pagopa-afm-marketplace-be-service.repository.name, "-", "")
    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    # prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

    # aks section
    k8s_namespace                = "afm"
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
  pagopa-afm-marketplace-be-service-variables_secret_deploy = {

  }
}

module "pagopa-afm-marketplace-be-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.2.0"
  count  = var.pagopa-afm-marketplace-be-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-afm-marketplace-be-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-afm-marketplace-service"


  variables = merge(
    local.pagopa-afm-marketplace-be-service-variables,
    local.pagopa-afm-marketplace-be-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-afm-marketplace-be-service-variables_secret,
    local.pagopa-afm-marketplace-be-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-afm-marketplace-be-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-afm-marketplace-be-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-afm-marketplace-be-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-afm-marketplace-service"

  variables = merge(
    local.pagopa-afm-marketplace-be-service-variables,
    local.pagopa-afm-marketplace-be-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-afm-marketplace-be-service-variables_secret,
    local.pagopa-afm-marketplace-be-service-variables_secret_deploy,
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
    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
  ]
}
