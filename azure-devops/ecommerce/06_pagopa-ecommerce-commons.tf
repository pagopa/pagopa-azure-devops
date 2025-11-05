variable "pagopa-ecommerce-commons" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-ecommerce-commons"
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
        project_key        = "pagopa_pagopa-ecommerce-commons"
        project_name       = "pagopa-ecommerce-commons"
      }
    }
  }
}

locals {
  # global vars
  pagopa-ecommerce-commons-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-ecommerce-commons.repository.branch_name
  }
  # global secrets
  pagopa-ecommerce-commons-variables_secret = {

  }
  # code_review vars
  pagopa-ecommerce-commons-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-ecommerce-commons.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-ecommerce-commons.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-ecommerce-commons.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-ecommerce-commons.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-ecommerce-commons-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-ecommerce-commons-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id
  }
  # deploy secrets
  pagopa-ecommerce-commons-variables_secret_deploy = {

  }
}

module "pagopa-ecommerce-ecommerce-commons_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-ecommerce-commons.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-commons.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-ecommerce-commons"
  ci_trigger_use_yaml          = true

  variables = merge(
    local.pagopa-ecommerce-commons-variables,
    local.pagopa-ecommerce-commons-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-commons-variables_secret,
    local.pagopa-ecommerce-commons-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-ecommerce-ecommerce-commons_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-ecommerce-commons.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-commons.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-ecommerce-commons"

  variables = merge(
    local.pagopa-ecommerce-commons-variables,
    local.pagopa-ecommerce-commons-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-commons-variables_secret,
    local.pagopa-ecommerce-commons-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
