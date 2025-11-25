variable "pagopa-selfcare-backoffice-scheduler" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-selfcare-backoffice-scheduler"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pagopa"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      sonarcloud = {
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-selfcare-backoffice-scheduler"
        project_name       = "pagopa-selfcare-backoffice-scheduler"
      }
    }
  }
}

locals {
  # global vars
  pagopa-selfcare-backoffice-scheduler-variables = {
    default_branch = var.pagopa-selfcare-backoffice-scheduler.repository.branch_name
  }

  # global secrets
  pagopa-selfcare-backoffice-scheduler-variables_secret = {

  }

  # code_review vars
  pagopa-selfcare-backoffice-scheduler-variables_code_review = {
    sonarcloud_service_conn = var.pagopa-selfcare-backoffice-scheduler.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-selfcare-backoffice-scheduler.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-selfcare-backoffice-scheduler.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-selfcare-backoffice-scheduler.pipeline.sonarcloud.project_name
  }

  # code_review secrets
  pagopa-selfcare-backoffice-scheduler-variables_secret_code_review = {
  }
}

module "pagopa-selfcare-backoffice-scheduler_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
  count  = var.pagopa-selfcare-backoffice-scheduler.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-selfcare-backoffice-scheduler.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-selfcare-backoffice-scheduler"

  ci_trigger_use_yaml = true

  variables = merge(
    local.pagopa-selfcare-backoffice-scheduler-variables,
    local.pagopa-selfcare-backoffice-scheduler-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-selfcare-backoffice-scheduler-variables_secret,
    local.pagopa-selfcare-backoffice-scheduler-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}
