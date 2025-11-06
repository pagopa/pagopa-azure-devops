variable "pagopa-wallet-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-wallet-service"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pay-wallet"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      sonarcloud = {
        # TODO azure devops terraform provider does not support SonarCloud service endpoint
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-wallet-service"
        project_name       = "pagopa-wallet-service"
      }
    }
  }
}

locals {
  # global vars
  pagopa-wallet-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-wallet-service.repository.branch_name
  }
  # global secrets
  pagopa-wallet-service-variables_secret = {

  }
  # code_review vars
  pagopa-wallet-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-wallet-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-wallet-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-wallet-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-wallet-service.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-wallet-service-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-wallet-service-variables_deploy = {
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    # acr section
    k8s_image_repository_name            = replace(var.pagopa-wallet-service.repository.name, "-", "")
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.id
    dev_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.service_endpoint_name
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.id
    uat_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.service_endpoint_name
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.id
    prod_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.service_endpoint_name

    # aks section
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace  = "pagopaditncoreacr.azurecr.io"
    uat_container_namespace  = "pagopauitncoreacr.azurecr.io"
    prod_container_namespace = "pagopapitncoreacr.azurecr.io"

  }
  # deploy secrets
  pagopa-wallet-service-variables_secret_deploy = {
    git_mail              = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username          = module.secrets.values["azure-devops-github-USERNAME"].value
    tenant_id             = data.azurerm_client_config.current.tenant_id
    wallet_token_test_dev = module.wallet_dev_secrets.values["wallet-token-test-key"].value
    # wallet_token_test_uat            = module.wallet_uat_secrets.values["wallet-token-test-key"].value
    migration_api_key_test_dev       = module.wallet_dev_secrets.values["wallet-migration-api-key-test-dev"].value
    migration_cstar_api_key_test_dev = module.wallet_dev_secrets.values["wallet-migration-cstar-api-key-test-dev"].value
    migration_wallet_token_test_dev  = module.wallet_dev_secrets.values["migration-wallet-token-test-dev"].value
  }
}

module "pagopa-wallet-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-wallet-service.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-wallet-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-wallet-service"
  ci_trigger_use_yaml          = true

  variables = merge(
    local.pagopa-wallet-service-variables,
    local.pagopa-wallet-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-wallet-service-variables_secret,
    local.pagopa-wallet-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-wallet-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-wallet-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-wallet-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-wallet-service"

  variables = merge(
    local.pagopa-wallet-service-variables,
    local.pagopa-wallet-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-wallet-service-variables_secret,
    local.pagopa-wallet-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
