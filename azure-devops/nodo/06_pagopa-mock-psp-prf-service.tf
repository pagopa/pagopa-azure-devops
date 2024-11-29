variable "pagopa-mock-psp-prf-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-nodo-dei-pagamenti-test-psp"
      branch_name     = "refs/heads/develop"
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
  pagopa-mock-psp-prf-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-mock-psp-prf-service.repository.branch_name
  }
  # global secrets
  pagopa-mock-psp-prf-service-variables_secret = {

  }

  # deploy vars
  pagopa-mock-psp-prf-service-variables_deploy = {
    git_email         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository_name = replace(var.pagopa-mock-psp-prf-service.repository.name, "-", "")
    repository            = replace(var.pagopa-mock-psp-prf-service.repository.name, "-", "")


    uat_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id
    uat_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.service_endpoint_name

    # aks section
    k8s_namespace               = "nodo"
    uat_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_uat.id

    uat_container_namespace = "pagopaucommonacr.azurecr.io"

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

  }
  # deploy secrets
  pagopa-mock-psp-prf-service-variables_secret_deploy = {

  }
}



module "pagopa-mock-psp-prf-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-mock-psp-prf-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-mock-psp-prf-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-mock-psp-prf-service"

  variables = merge(
    local.pagopa-mock-psp-prf-service-variables,
    local.pagopa-mock-psp-prf-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-mock-psp-prf-service-variables_secret,
    local.pagopa-mock-psp-prf-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
