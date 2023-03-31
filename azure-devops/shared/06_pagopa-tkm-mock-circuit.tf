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

    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name

    # acr section
    image_repository_name               = replace(var.pagopa-tkm-mock-circuit.repository.name, "-", "")
    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id

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
    tenant_id    = module.secrets.values["TENANTID"].value
  }
}

module "pagopa-tkm-mock-circuit_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.6.5"
  count  = var.pagopa-tkm-mock-circuit.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-tkm-mock-circuit.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
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
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-tkm-mock-circuit_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-tkm-mock-circuit.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-tkm-mock-circuit.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
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
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
  ]
}