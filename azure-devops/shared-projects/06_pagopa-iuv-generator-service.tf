variable "pagopa-iuv-generator-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-iuv-generator"
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
        project_key        = "pagopa_pagopa-iuv-generator"
        project_name       = "pagopa-iuv-generator"
      }
    }
  }
}

locals {
  # global vars
  pagopa-iuv-generator-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-iuv-generator-service.repository.branch_name
  }
  # global secrets
  pagopa-iuv-generator-service-variables_secret = {

  }
  # code_review vars
  pagopa-iuv-generator-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-iuv-generator-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-iuv-generator-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-iuv-generator-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-iuv-generator-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-iuv-generator-service-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-iuv-generator-service-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    image_repository_name               = replace(var.pagopa-iuv-generator-service.repository.name, "-", "")
    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id

    # aks section
    k8s_namespace               = "shared"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id


    dev_container_namespace = "pagopadcommonacr.azurecr.io"
    # uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    # prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-iuv-generator-service-variables_secret_deploy = {

  }
}

module "pagopa-iuv-generator-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.2.0"
  count  = var.pagopa-iuv-generator-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-iuv-generator-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-iuv-generator-service"


  variables = merge(
    local.pagopa-iuv-generator-service-variables,
    local.pagopa-iuv-generator-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-iuv-generator-service-variables_secret,
    local.pagopa-iuv-generator-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-iuv-generator-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-iuv-generator-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-iuv-generator-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-iuv-generator-service"

  variables = merge(
    local.pagopa-iuv-generator-service-variables,
    local.pagopa-iuv-generator-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-iuv-generator-service-variables_secret,
    local.pagopa-iuv-generator-service-variables_secret_deploy,
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
