variable "pagopa-notifications-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-notifications-service"
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
        project_key        = "pagopa_pagopa-notifications-service"
        project_name       = "pagopa-notifications-service"
      }
    }
  }
}

locals {
  # global vars
  pagopa-notifications-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-notifications-service.repository.branch_name
  }
  # global secrets
  pagopa-notifications-service-variables_secret = {

  }
  # code_review vars
  pagopa-notifications-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-notifications-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-notifications-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-notifications-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-notifications-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-notifications-service-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-notifications-service-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev.id
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat.id
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod.id
    k8s_image_repository_name            = replace(var.pagopa-notifications-service.repository.name, "-", "")
    dev_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.dev.service_endpoint_name
    uat_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.uat.service_endpoint_name
    prod_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.prod.service_endpoint_name

    # aks section
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

  }
  # deploy secrets
  pagopa-notifications-service-variables_secret_deploy = {
    notifications_service_testing_api_key_dev = module.ecommerce_dev_secrets.values["notifications-service-testing-api-key"].value
    notifications_service_testing_mail_dev    = module.ecommerce_dev_secrets.values["notifications-service-testing-mail"].value
    notifications_service_testing_api_key_uat = module.ecommerce_uat_secrets.values["notifications-service-testing-api-key"].value
    notifications_service_testing_mail_uat    = module.ecommerce_uat_secrets.values["notifications-service-testing-mail"].value
    approve_touchpoint_mail                   = module.ecommerce_prod_secrets.values["touchpoint-mail"].value
  }
}

module "pagopa-ecommerce-notifications-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.2.1"
  count  = var.pagopa-notifications-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-notifications-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-notifications-service"

  variables = merge(
    local.pagopa-notifications-service-variables,
    local.pagopa-notifications-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-notifications-service-variables_secret,
    local.pagopa-notifications-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-ecommerce-notifications-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-notifications-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-notifications-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-notifications-service"

  variables = merge(
    local.pagopa-notifications-service-variables,
    local.pagopa-notifications-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-notifications-service-variables_secret,
    local.pagopa-notifications-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev.id,
    data.azuredevops_serviceendpoint_azurecr.uat.id,
    data.azuredevops_serviceendpoint_azurecr.prod.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
