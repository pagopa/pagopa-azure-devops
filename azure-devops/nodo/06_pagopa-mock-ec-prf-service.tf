variable "pagopa-mock-ec-prf-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-nodo-dei-pagamenti-test"
      branch_name     = "refs/heads/feature/mock-ec-pf"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = false
      enable_deploy      = true
    }
  }
}

locals {
  # global vars
  pagopa-mock-ec-prf-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-mock-ec-prf-service.repository.branch_name
  }
  # global secrets
  pagopa-mock-ec-prf-service-variables_secret = {

  }

  # deploy vars
  pagopa-mock-ec-prf-service-variables_deploy = {
    git_email         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    image_repository_name                     = replace(var.pagopa-mock-ec-prf-service.repository.name, "-", "")
    container-registry-service-connection-dev = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    repository                                = replace(var.pagopa-mock-ec-prf-service.repository.name, "-", "")

    uat_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id

    # aks section
    k8s_namespace               = "nodo"
    uat_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_uat.id

    uat_container_namespace = "pagopaucommonacr.azurecr.io"

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

    # nodo4 variables of cd pipeline
    kv-service-connection-dev         = "DEV-PAGOPA-SERVICE-CONN"
    az-kv-name-dev                    = local.dev_nodo_key_vault_name # kv name
    kubernetes-service-connection-dev = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    deploy-pool-dev                   = "pagopa-dev-linux"
  }
  # deploy secrets
  pagopa-mock-ec-prf-service-variables_secret_deploy = {

  }
}



module "pagopa-mock-ec-prf-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-mock-ec-prf-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-mock-ec-prf-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-mock-ec-prf-service"

  variables = merge(
    local.pagopa-mock-ec-prf-service-variables,
    local.pagopa-mock-ec-prf-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-mock-ec-prf-service-variables_secret,
    local.pagopa-mock-ec-prf-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
