variable "pagopa-jwt-issuer-service" {
  default = {
    repository = {
      organization   = "pagopa"
      name           = "pagopa-jwt-issuer-service" #repo template that contains code to be deployed to both payment wallet and ecommerce domains
      branch_name    = "refs/heads/main"
      pipelines_path = ".devops"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      sonarcloud = {
        # TODO azure devops terraform provider does not support SonarCloud service endpoint
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-jwt-issuer-service"
        project_name       = "pagopa-jwt-issuer-service"
      }
    }
  }
}

locals {

  pagopa-jwt-issuer-service-code-review-repository-conf = {
    yml_prefix_name = null
  }

  pagopa-jwt-issuer-service-deploy-repository-conf = {
    yml_prefix_name = "ecommerce"
  }

  # global vars
  pagopa-jwt-issuer-service-variables = {
    default_branch = var.pagopa-jwt-issuer-service.repository.branch_name
  }
  # global secrets
  pagopa-jwt-issuer-service-variables_secret = {

  }
  # code_review vars
  pagopa-jwt-issuer-service-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-jwt-issuer-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-jwt-issuer-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-jwt-issuer-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-jwt-issuer-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-jwt-issuer-service-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-jwt-issuer-service-variables_deploy = {

    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    # acr section
    k8s_image_repository_name            = replace(var.pagopa-jwt-issuer-service.repository.name, "-", "")
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id
    dev_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.service_endpoint_name
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id
    uat_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.service_endpoint_name
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.id
    prod_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.prod_weu_workload_identity.service_endpoint_name

    # aks section
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-jwt-issuer-service-variables_secret_deploy = {
    tenant_id    = data.azurerm_client_config.current.tenant_id
    git_mail     = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value

  }
}

module "pagopa-jwt-issuer-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-jwt-issuer-service.pipeline.enable_code_review == true ? 1 : 0

  project_id = data.azuredevops_project.project.id
  repository = merge(
    var.pagopa-jwt-issuer-service.repository,
    local.pagopa-jwt-issuer-service-code-review-repository-conf
  )
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id

  path = "${local.domain}\\pagopa-jwt-issuer-service"

  variables = merge(
    local.pagopa-jwt-issuer-service-variables,
    local.pagopa-jwt-issuer-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-jwt-issuer-service-variables_secret,
    local.pagopa-jwt-issuer-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}

module "pagopa-jwt-issuer-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-jwt-issuer-service.pipeline.enable_deploy == true ? 1 : 0

  project_id = data.azuredevops_project.project.id
  repository = merge(
    var.pagopa-jwt-issuer-service.repository,
    local.pagopa-jwt-issuer-service-deploy-repository-conf
  )
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id

  path = "${local.domain}\\pagopa-jwt-issuer-service"

  variables = merge(
    local.pagopa-jwt-issuer-service-variables,
    local.pagopa-jwt-issuer-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-jwt-issuer-service-variables_secret,
    local.pagopa-jwt-issuer-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
