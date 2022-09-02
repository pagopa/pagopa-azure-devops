variable "pagopa-selc-backoffice-backend" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-selfcare-ms-backoffice-backend"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
    }
  }
}

locals {
  # global vars
  pagopa-selc-backoffice-backend-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-selc-backoffice-backend.branch_name

    settings_xml_rw_secure_file_name = "settings-rw.xml"
    settings_xml_ro_secure_file_name = "settings-ro.xml"
    maven_remote_repo_server_id      = "selc"
    maven_remote_repo                = "https://pkgs.dev.azure.com/pagopaspa/selfcare-projects/_packaging/selfcare/maven/v1"
    dockerfile                       = "Dockerfile"

    
  }
  
  # global secrets
  pagopa-selc-backoffice-backend-variables_secret = {

  }
  # code_review vars
  pagopa-selc-backoffice-backend-variables_code_review = {
    sonarcloud_service_conn = "SONARCLOUD-SERVICE-CONN"
    sonarcloud_org          = var.pagopa-selc-backoffice-backend.repository.organization
    sonarcloud_project_key  = "${var.pagopa-selc-backoffice-backend.repository.organization}_${var.pagopa-selc-backoffice-backend.repository.name}"
    sonarcloud_project_name = var.pagopa-selc-backoffice-backend.repository.name
  }
  # code_review secrets
  pagopa-selc-backoffice-backend-variables_secret_code_review = {
    danger_github_api_token = "skip"
  }
  # deploy vars
  pagopa-selc-backoffice-backend-variables_deploy = {
    git_mail                = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username            = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection       = azuredevops_serviceendpoint_github.azure-devops-github-pr.service_endpoint_name
    healthcheck_endpoint    = "/api/v1/info"
    dev_azure_subscription  = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    uat_azure_subscription  = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    prod_azure_subscription = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name

    tenant_id = module.secrets.values["TENANTID"].value

    # acr section
    # k8s_image_repository_name = replace(var.pagopa-selc-backoffice-backend.repository.name, "-", "")
    image_repository = replace(var.pagopa-selc-backoffice-backend.repository.name, "-", "")

    #dev_container_registry_service_conn
    dev_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.service_endpoint_name
    #uat_container_registry_service_conn
    uat_container_registry  = azuredevops_serviceendpoint_azurecr.acr_docker_registry_uat.service_endpoint_name
    #prod_container_registry_service_conn
    prod_container_registry = azuredevops_serviceendpoint_azurecr.acr_docker_registry_prod.service_endpoint_name

    #dev_container_registry_name
    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    #uat_container_registry_name
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    #prod_container_registry_name
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    dev_kubernetes_service_conn          = azuredevops_serviceendpoint_kubernetes.sia-docker-registry-dev.service_endpoint_name
    dev_agent_pool                       = "pagopa-dev-linux"
    uat_kubernetes_service_conn          = azuredevops_serviceendpoint_kubernetes.sia-docker-registry-uat.service_endpoint_name
    uat_agent_pool                       = "pagopa-uat-linux"
    prod_kubernetes_service_conn         = azuredevops_serviceendpoint_kubernetes.sia-docker-registry-prod.service_endpoint_name
    prod_agent_pool                      = "pagopa-prod-linux"  
    deploy_namespace                     = "selc"
    deployment_name                      = "external-api"
  }
  # deploy secrets
  pagopa-selc-backoffice-backend-variables_secret_deploy = {

  }
}

module "pagopa-selc-backoffice-backend_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-selc-backoffice-backend.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-selc-backoffice-backend.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.pagopa-selc-backoffice-backend-variables,
    local.pagopa-selc-backoffice-backend-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-selc-backoffice-backend-variables_secret,
    local.pagopa-selc-backoffice-backend-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-selc-backoffice-backend_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-selc-backoffice-backend.pipeline.enable_deploy == true ? 1 : 0
  
  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-selc-backoffice-backend.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  ci_trigger_use_yaml = true

  variables = merge(
    local.pagopa-selc-backoffice-backend-variables,
    local.pagopa-selc-backoffice-backend-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-selc-backoffice-backend-variables_secret,
    local.pagopa-selc-backoffice-backend-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
  #  azuredevops_serviceendpoint_azurecr.acr_docker_registry_dev.id,
  #  azuredevops_serviceendpoint_kubernetes.sia-docker-registry-dev.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
  #  azuredevops_serviceendpoint_azurecr.acr_docker_registry_uat.id,
  #  azuredevops_serviceendpoint_dockerregistry.sia-docker-registry-uat.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  #  azuredevops_serviceendpoint_azurecr.acr_docker_registry_prod.id,
  #  azuredevops_serviceendpoint_dockerregistry.sia-docker-registry-prod.id,
  ]
}
