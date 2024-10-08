variable "pagopa-mock-pm-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-nodo-dei-pagamenti-test-pm"
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
  pagopa-mock-pm-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-mock-pm-service.repository.branch_name
  }
  # global secrets
  pagopa-mock-pm-service-variables_secret = {

  }

  # deploy vars
  pagopa-mock-pm-service-variables_deploy = {
    git_email         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository_name = replace(var.pagopa-mock-pm-service.repository.name, "-", "")
    repository            = replace(var.pagopa-mock-pm-service.repository.name, "-", "")

    dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id

    # aks section
    k8s_namespace               = "nodo"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id

    dev_container_namespace = "pagopadcommonacr.azurecr.io"

    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id
  }
  # deploy secrets
  pagopa-mock-pm-service-variables_secret_deploy = {

  }
}



module "pagopa-mock-pm-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-mock-pm-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-mock-pm-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-mock-pm-service"

  variables = merge(
    local.pagopa-mock-pm-service-variables,
    local.pagopa-mock-pm-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-mock-pm-service-variables_secret,
    local.pagopa-mock-pm-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
