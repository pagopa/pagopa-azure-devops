variable "pagopa-fdr-nodo-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-fdr-nodo-dei-pagamenti"
      branch_name     = "refs/heads/main"
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
        project_key        = "pagopa_pagopa-fdr-nodo-dei-pagamenti"
        project_name       = "pagopa-fdr-nodo-dei-pagamenti"
      }
      suspend_job = {
        enabled               = true
        name                  = "suspend-job-pipeline"
        pipeline_yml_filename = "suspend-job-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-fdr-nodo-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-fdr-nodo-service.repository.branch_name
  }
  # global secrets
  pagopa-fdr-nodo-service-variables_secret = {

  }
  # code_review vars
  pagopa-fdr-nodo-service-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-fdr-nodo-service.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-fdr-nodo-service.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-fdr-nodo-service.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-fdr-nodo-service.pipeline.sonarcloud.project_name
    # fdr variables of cd pipeline
  }
  # code_review secrets
  pagopa-fdr-nodo-service-variables_secret_code_review = {
    lightbend_key_dev = module.fdr_dev_secrets.values["lightbend-key"].value
    lightbend_key_uat = module.fdr_dev_secrets.values["lightbend-key"].value
    #    lightbend_key_prod = module.fdr_dev_secrets.values["lightbend-key"].value
  }
  # deploy vars
  pagopa-fdr-nodo-service-variables_deploy = {
    git_email         = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    image_repository_name                     = replace(var.pagopa-fdr-nodo-service.repository.name, "-", "")
    container-registry-service-connection-dev = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    repository                                = replace(var.pagopa-fdr-nodo-service.repository.name, "-", "")

    dev_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    #    prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

    # aks section
    k8s_namespace               = "fdr"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    #    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace = "pagopadcommonacr.azurecr.io"
    uat_container_namespace = "pagopaucommonacr.azurecr.io"
    #    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    # fdr variables of cd pipeline
    deploy-pool-dev = "pagopa-dev-linux"
    deploy-pool-uat = "pagopa-uat-linux"
    #    deploy-pool-prod = "pagopa-prod-linux"
  }
  # deploy secrets
  pagopa-fdr-nodo-service-variables_secret_deploy = {
    lightbend_key_dev = module.fdr_dev_secrets.values["lightbend-key"].value
    lightbend_key_uat = module.fdr_dev_secrets.values["lightbend-key"].value
    #    lightbend_key_prod = module.fdr_dev_secrets.values["lightbend-key"].value
  }

  # integration vars
  pagopa-fdr-nodo-service-variables_integration_test = {
    github_connection               = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tf_dev_azure_service_connection = "io-azure-devops-github-rw"
  }
  # integration secrets
  pagopa-fdr-nodo-service-variables_secret_integration_test = {
  }
  # performance vars
  pagopa-fdr-nodo-service-variables_performance_test = {
    github_connection               = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tf_dev_azure_service_connection = "io-azure-devops-github-rw"
  }
  # performance secrets
  pagopa-fdr-nodo-service-variables_secret_performance_test = {
  }

  # performance vars
  pagopa-fdr-nodo-service-variables_suspend_job = {
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    # aks section
    k8s_namespace               = "fdr"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    #    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

  }
  # performance secrets
  pagopa-fdr-nodo-service-variables_secret_suspend_job = {
  }
}

module "pagopa-fdr-nodo-service_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=add_ci_trigger_code_review"
  count  = var.pagopa-fdr-nodo-service.pipeline.enable_code_review == true ? 1 : 0

  project_id = data.azuredevops_project.project.id
  repository = var.pagopa-fdr-nodo-service.repository
  # github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-fdr-nodo-service"

  pull_request_trigger_use_yaml = true
  ci_trigger_use_yaml           = true

  variables = merge(
    local.pagopa-fdr-nodo-service-variables,
    local.pagopa-fdr-nodo-service-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-fdr-nodo-service-variables_secret,
    local.pagopa-fdr-nodo-service-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-fdr-nodo-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-fdr-nodo-service.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-fdr-nodo-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-fdr-nodo-service"

  variables = merge(
    local.pagopa-fdr-nodo-service-variables,
    local.pagopa-fdr-nodo-service-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-fdr-nodo-service-variables_secret,
    local.pagopa-fdr-nodo-service-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id,
    #    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    #    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
    #    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}

module "pagopa-fdr-nodo-service_suspend_job" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v2.6.3"
  count  = var.pagopa-fdr-nodo-service.pipeline.suspend_job.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-fdr-nodo-service.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  # github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  path                  = "${local.domain}\\pagopa-fdr-nodo-service"
  pipeline_name         = var.pagopa-fdr-nodo-service.pipeline.suspend_job.name
  pipeline_yml_filename = var.pagopa-fdr-nodo-service.pipeline.suspend_job.pipeline_yml_filename

  variables = merge(
    local.pagopa-fdr-nodo-service-variables,
    local.pagopa-fdr-nodo-service-variables_suspend_job,
  )

  variables_secret = merge(
    local.pagopa-fdr-nodo-service-variables_secret,
    local.pagopa-fdr-nodo-service-variables_secret_suspend_job,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}