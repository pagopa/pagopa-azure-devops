variable "pagopa-mock-ec-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-mock-ec"
      branch_name     = "refs/heads/main"
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
  pagopa-mock-ec-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-mock-ec-service.repository.branch_name
  }
  # global secrets
  pagopa-mock-ec-service-variables_secret = {

  }

  # deploy vars
  pagopa-mock-ec-service-variables_deploy = {
    git_email         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository_name = replace(var.pagopa-mock-ec-service.repository.name, "-", "")
    repository            = replace(var.pagopa-mock-ec-service.repository.name, "-", "")

    dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev.id
    uat_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.uat.id

    # aks section
    k8s_namespace               = "mock"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_uat.id

    dev_container_namespace = "pagopadcommonacr.azurecr.io"
    uat_container_namespace = "pagopaucommonacr.azurecr.io"

    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id
    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id
  }

  # deploy secrets
  pagopa-mock-ec-service-variables_secret_deploy = {

  }
}



module "pagopa-mock-ec-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-mock-ec-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-mock-ec-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-mock-ec-service"

  variables = merge(
    local.pagopa-mock-ec-service-variables,
    local.pagopa-mock-ec-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-mock-ec-service-variables_secret,
    local.pagopa-mock-ec-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev.id,
    data.azuredevops_serviceendpoint_azurecr.uat.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
