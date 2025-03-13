variable "pagopa-checkout-identity-provider-mock" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-checkout-identity-provider-mock"
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
        project_key        = "pagopa_pagopa-checkout-identity-provider-mock"
        project_name       = "pagopa-checkout-identity-provider-mock"
      }
    }
  }
}

locals {
  # global vars
  pagopa-checkout-identity-provider-mock-variables = {
    default_branch = var.pagopa-checkout-identity-provider-mock.repository.branch_name
  }
  # global secrets
  pagopa-checkout-identity-provider-mock-variables_secret = {

  }

  # deploy vars
  pagopa-checkout-identity-provider-mock-variables_deploy = {
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    # acr section
    k8s_image_repository_name            = replace(var.pagopa-checkout-identity-provider-mock.repository.name, "-", "")
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id
    dev_container_registry_name          = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.service_endpoint_name

    # aks section
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
  }
  # deploy secrets
  pagopa-checkout-identity-provider-mock-variables_secret_deploy = {
    git_mail     = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
    tenant_id    = data.azurerm_client_config.current.tenant_id
  }
}

module "pagopa-checkout-identity-provider-mock_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-checkout-identity-provider-mock.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-checkout-identity-provider-mock.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-checkout-identity-provider-mock"

  variables = merge(
    local.pagopa-checkout-identity-provider-mock-variables,
    local.pagopa-checkout-identity-provider-mock-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-checkout-identity-provider-mock-variables_secret,
    local.pagopa-checkout-identity-provider-mock-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
  ]
}
