variable "pagopa-mock-ec-prf-service" {
  default = {
    repository = {
      organization    = "pagopa"

      # https://pagopa.atlassian.net/wiki/spaces/PPA/pages/550012487/Censimento+mock+test+NODO+PM

      # Node - pagoPA
      # name            = "pagopa-mock-ec"
      # branch_name     = "refs/heads/develop"
      # branch_name     = "refs/heads/develop_main"

      # Java - Nexi
      name            = "pagopa-nodo-dei-pagamenti-test-ec"
      # branch_name     = "refs/heads/deploy-pagopa"
      # branch_name     = "refs/heads/mock-ec-prf-embedded"
      branch_name     = "refs/heads/perf-pagopa"

      # name            = "pagopa-nodo-dei-pagamenti-test"
      # branch_name     = "refs/heads/NOD-prf-data-dump"

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
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository_name                     = replace(var.pagopa-mock-ec-prf-service.repository.name, "-", "")
    container-registry-service-connection-dev = data.azuredevops_serviceendpoint_azurecr.dev_weu_workload_identity.id
    repository                                = replace(var.pagopa-mock-ec-prf-service.repository.name, "-", "")

    uat_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id
    uat_container_registry_name         = data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.service_endpoint_name

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
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-mock-ec-prf-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-mock-ec-prf-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
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
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.uat_weu_workload_identity.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
