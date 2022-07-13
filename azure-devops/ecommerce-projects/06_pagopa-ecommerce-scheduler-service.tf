variable "pagopa-ecommerce-scheduler-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-ecommerce-scheduler-service"
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
        project_key        = "pagopa_pagopa-ecommerce-scheduler-service"
        project_name       = "pagopa-ecommerce-scheduler-service"
      }
    }
  }
}

locals {
  # global vars
  pagopa-ecommerce-scheduler-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-ecommerce-scheduler-service.repository.branch_name
  }
  # global secrets
  pagopa-ecommerce-scheduler-service-variables_secret = {

  }
  # code_review vars
  pagopa-ecommerce-scheduler-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-ecommerce-scheduler-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-ecommerce-scheduler-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-ecommerce-scheduler-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-ecommerce-scheduler-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-ecommerce-scheduler-service-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-ecommerce-scheduler-service-variables_deploy = {
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    k8s_image_repository_name           = replace(var.pagopa-ecommerce-scheduler-service.repository.name, "-", "")
    dev_container_registry_name         = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_name

    # uat_container_registry  = azuredevops_serviceendpoint_azurecr.acr_aks_uat.service_endpoint_name
    # prod_container_registry = azuredevops_serviceendpoint_azurecr.acr_aks_prod.service_endpoint_name

    # aks section
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id

    dev_container_namespace = "pagopapcommonacr.azurecr.io"
    # uat_container_namespace  = "pagopapcommonacr.azurecr.io"
    # prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-ecommerce-scheduler-service-variables_secret_deploy = {

  }
}

module "pagopa-ecommerce-scheduler-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.4.0"
  count  = var.pagopa-ecommerce-scheduler-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-scheduler-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-ecommerce-scheduler-service"

  variables = merge(
    local.pagopa-ecommerce-scheduler-service-variables,
    local.pagopa-ecommerce-scheduler-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-scheduler-service-variables_secret,
    local.pagopa-ecommerce-scheduler-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-ecommerce-scheduler-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.4.0"
  count  = var.pagopa-ecommerce-scheduler-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-scheduler-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-ecommerce-scheduler-service"

  variables = merge(
    local.pagopa-ecommerce-scheduler-service-variables,
    local.pagopa-ecommerce-scheduler-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-scheduler-service-variables_secret,
    local.pagopa-ecommerce-scheduler-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    # azuredevops_serviceendpoint_azurecr.acr_aks_uat.id,
    # azuredevops_serviceendpoint_azurecr.acr_aks_prod.id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    # azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    # azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
