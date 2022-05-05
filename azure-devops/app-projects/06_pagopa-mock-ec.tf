variable "pagopa-mock-ec" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-mock-ec"
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
  pagopa-mock-ec-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-mock-ec.repository.branch_name
  }
  # global secrets
  pagopa-mock-ec-variables_secret = {

  }
  # code_review vars
  pagopa-mock-ec-variables_code_review = {
    danger_github_api_token = "skip"
  }
  # code_review secrets
  pagopa-mock-ec-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-mock-ec-variables_deploy = {
    git_mail                                      = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username                                  = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection                             = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    healthcheck_endpoint                          = "/api/v1/info"    #todo
    dev_deploy_type                               = "production_slot" #or staging_slot_and_swap
    dev_azure_subscription                        = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    dev_web_app_name                              = "pagopa-d-app-mock-ec"
    dev_web_app_resource_group_name               = "pagopa-d-mock-ec-rg"
    dev_healthcheck_container_resource_group_name = "NA"
    dev_healthcheck_container_vnet                = "NA"
    uat_deploy_type                               = "production_slot" #or staging_slot_and_swap
    uat_azure_subscription                        = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    uat_web_app_name                              = "pagopa-u-app-mock-ec"
    uat_web_app_resource_group_name               = "pagopa-u-mock-ec-rg"
    uat_healthcheck_container_resource_group_name = "NA"
    uat_healthcheck_container_vnet                = "NA"
  }
  # deploy secrets
  pagopa-mock-ec-variables_secret_deploy = {

  }
}

module "pagopa-mock-ec_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-mock-ec.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-mock-ec.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-mock-ec-variables,
    local.pagopa-mock-ec-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-mock-ec-variables_secret,
    local.pagopa-mock-ec-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
  ]
}

module "pagopa-mock-ec_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-mock-ec.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-mock-ec.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-mock-ec-variables,
    local.pagopa-mock-ec-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-mock-ec-variables_secret,
    local.pagopa-mock-ec-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
  ]
}
