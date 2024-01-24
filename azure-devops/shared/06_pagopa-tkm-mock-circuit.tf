variable "pagopa-tkm-mock-circuit" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "tkm-mock-circuit"
      branch_name     = "refs/heads/develop"
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
        project_key        = "pagopa_tkm-mock-circuit"
        project_name       = "tkm-mock-circuit"
      }
    }
  }
}

locals {
  # global vars
  pagopa-tkm-mock-circuit-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-tkm-mock-circuit.repository.branch_name
  }
  # global secrets
  pagopa-tkm-mock-circuit-variables_secret = {

  }
  # code_review vars
  pagopa-tkm-mock-circuit-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-tkm-mock-circuit.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-tkm-mock-circuit.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-tkm-mock-circuit.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-tkm-mock-circuit.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-tkm-mock-circuit-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-tkm-mock-circuit-variables_deploy = {

    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    # acr section
    image_repository_name               = replace(var.pagopa-tkm-mock-circuit.repository.name, "-", "")
    dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev.id
    uat_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.uat.id

    # aks section
    k8s_namespace               = "shared"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_uat.id

    dev_container_namespace = "pagopadcommonacr.azurecr.io"
    uat_container_namespace = "pagopaucommonacr.azurecr.io"
  }
  # deploy secrets
  pagopa-tkm-mock-circuit-variables_secret_deploy = {
    git_mail     = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
    tenant_id    = data.azurerm_client_config.current.tenant_id
  }
}

module "pagopa-tkm-mock-circuit_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-tkm-mock-circuit.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-tkm-mock-circuit.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-tkm-mock-circuit"

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.pagopa-tkm-mock-circuit-variables,
    local.pagopa-tkm-mock-circuit-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-tkm-mock-circuit-variables_secret,
    local.pagopa-tkm-mock-circuit-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-tkm-mock-circuit_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-tkm-mock-circuit.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-tkm-mock-circuit.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-tkm-mock-circuit"

  variables = merge(
    local.pagopa-tkm-mock-circuit-variables,
    local.pagopa-tkm-mock-circuit-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-tkm-mock-circuit-variables_secret,
    local.pagopa-tkm-mock-circuit-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev.id,
    data.azuredevops_serviceendpoint_azurecr.uat.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
  ]
}
