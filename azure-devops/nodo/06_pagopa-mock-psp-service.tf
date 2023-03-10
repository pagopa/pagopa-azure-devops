variable "pagopa-mock-psp-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-mock-psp-service"
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
  pagopa-mock-psp-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-mock-psp-service.repository.branch_name
  }
  # global secrets
  pagopa-mock-psp-service-variables_secret = {

  }

  # deploy vars
  pagopa-mock-psp-service-variables_deploy = {
    git_email         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    image_repository_name = replace(var.pagopa-mock-psp-service.repository.name, "-", "")
    repository            = replace(var.pagopa-mock-psp-service.repository.name, "-", "")

    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id

    # aks section
    k8s_namespace               = "nodo"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id

    dev_container_namespace = "pagopadcommonacr.azurecr.io"

    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id

  }
  # deploy secrets
  pagopa-mock-psp-service-variables_secret_deploy = {

  }
}



module "pagopa-mock-psp-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-mock-psp-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-mock-psp-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-mock-psp-service"

  variables = merge(
    local.pagopa-mock-psp-service-variables,
    local.pagopa-mock-psp-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-mock-psp-service-variables_secret,
    local.pagopa-mock-psp-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
