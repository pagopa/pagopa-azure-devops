variable "pagopa-poc-quarkus" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-poc-quarkus"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      performance_test = {
        enabled               = true
        name                  = "performance-test-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
      sonarcloud = {
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-poc-quarkus"
        project_name       = "pagopa-poc-quarkus"
      }
    }
  }
}
# pagopa-poc-quarkus microservice deployed only in DEV
locals {
  # global vars
  pagopa-poc-quarkus-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-poc-quarkus.repository.branch_name
  }
  # global secrets
  pagopa-poc-quarkus-variables_secret = {
  }
  # code_review vars
  pagopa-poc-quarkus-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-poc-quarkus.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-poc-quarkus.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-poc-quarkus.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-poc-quarkus.pipeline.sonarcloud.project_name

    dev_container_registry = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
  }
  # code_review secrets
  pagopa-poc-quarkus-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-poc-quarkus-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    # acr section
    image_repository       = replace(var.pagopa-poc-quarkus.repository.name, "-", "")
    dev_container_registry = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id

    # aks section
    k8s_namespace               = "shared"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id

    dev_container_namespace = "pagopadcommonacr.azurecr.io"

    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id
  }
  # deploy secrets
  pagopa-poc-quarkus-variables_secret_deploy = {
    DEV_POC_ENROLLMENT_SUB_KEY = module.shared_dev_secrets.values["poc-d-reporting-enrollment-subscription-key"].value
  }
}

module "pagopa-poc-quarkus_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.2.0"
  count  = var.pagopa-poc-quarkus.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-poc-quarkus.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-poc-quarkus"

  variables = merge(
    local.pagopa-poc-quarkus-variables,
    local.pagopa-poc-quarkus-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-poc-quarkus-variables_secret,
    local.pagopa-poc-quarkus-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-poc-quarkus_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-poc-quarkus.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-poc-quarkus.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-poc-quarkus"

  variables = merge(
    local.pagopa-poc-quarkus-variables,
    local.pagopa-poc-quarkus-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-poc-quarkus-variables_secret,
    local.pagopa-poc-quarkus-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}

module "pagopa-poc-quarkus_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v2.6.3"
  count  = var.pagopa-poc-quarkus.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-poc-quarkus.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  path                         = "${local.domain}\\pagopa-poc-quarkus"
  pipeline_name                = var.pagopa-poc-quarkus.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-poc-quarkus.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-poc-quarkus-variables,
    local.pagopa-poc-quarkus-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-poc-quarkus-variables_secret,
    local.pagopa-poc-quarkus-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}