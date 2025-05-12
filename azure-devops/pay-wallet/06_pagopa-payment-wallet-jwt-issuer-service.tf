variable "pagopa-jwt-issuer-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-jwt-issuer-service" #repo template that contains code to be deployed to both payment wallet and ecommerce domains
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      
    }
    pipeline = {
      enable_deploy      = true
    }
  }
}

locals {

   pagopa-jwt-issuer-service-deploy-repository-conf = {
    yml_prefix_name = "pay-wallet"
  }

  # global vars
  pagopa-jwt-issuer-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-jwt-issuer-service.repository.branch_name
  }
  # global secrets
  pagopa-jwt-issuer-service-variables_secret = {

  }
  # deploy vars
  pagopa-jwt-issuer-service-variables_deploy = {
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    # acr section
    k8s_image_repository_name            = replace(var.pagopa-jwt-issuer-service.repository.name, "-", "")
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
  pagopa-jwt-issuer-service-variables_secret_deploy = {
    git_mail     = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
    tenant_id    = data.azurerm_client_config.current.tenant_id
  }
}

module "pagopa-jwt-issuer-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-jwt-issuer-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = merge(
    var.pagopa-jwt-issuer-service.repository,
    local.pagopa-jwt-issuer-service-deploy-repository-conf
  )
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-jwt-issuer-service"

  variables = merge(
    local.pagopa-jwt-issuer-service-variables,
    local.pagopa-jwt-issuer-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-jwt-issuer-service-variables_secret,
    local.pagopa-jwt-issuer-service-variables_secret_deploy,
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
