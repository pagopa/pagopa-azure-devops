variable "pagopa-posgw-common" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-posgw-common"
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
        project_key        = "pagopa_pagopa-posgw-common"
        project_name       = "pagopa-posgw-common"
      }
    }
  }
}

locals {
  # global vars
  pagopa-posgw-common-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-posgw-common.repository.branch_name
  }
  # global secrets
  pagopa-posgw-common-variables_secret = {

  }
  # code_review vars
  pagopa-posgw-common-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-posgw-common.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-posgw-common.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-posgw-common.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-posgw-common.pipeline.sonarcloud.project_name
  }
  # code_review secrets
  pagopa-posgw-common-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-posgw-common-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id
  }
  # deploy secrets
  pagopa-posgw-common-variables_secret_deploy = {

  }
}

module "pagopa-posgw-common_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-posgw-common.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-posgw-common.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-posgw-common"
  ci_trigger_use_yaml          = true

  variables = merge(
    local.pagopa-posgw-common-variables,
    local.pagopa-posgw-common-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-posgw-common-variables_secret,
    local.pagopa-posgw-common-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id
  ]
}

module "pagopa-posgw-common_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-posgw-common.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-posgw-common.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-posgw-common"

  variables = merge(
    local.pagopa-posgw-common-variables,
    local.pagopa-posgw-common-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-posgw-common-variables_secret,
    local.pagopa-posgw-common-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    # data.azuredevops_serviceendpoint_azurerm.uat.id,
    # data.azuredevops_serviceendpoint_azurerm.prod.id,
  ]
}
