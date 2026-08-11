variable "pagopa-portalpa" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-payments-department-centralhub"
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
  pagopa-portalpa-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-portalpa.repository.branch_name
  }

  # global secrets
  pagopa-portalpa-variables_secret = {}

  # code_review vars
  pagopa-portalpa-variables_code_review = {
    danger_github_api_token = "skip"
  }

  # code_review secrets
  pagopa-portalpa-variables_secret_code_review = {}

  # deploy vars
  pagopa-portalpa-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name

    # App Service
    dev_deploy_type                  = "production_slot" # direct deploy to production slot
    dev_azure_subscription           = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    dev_web_app_name                 = "pagopa-d-itn-portalpa-app"
    dev_web_app_resource_group_name  = "pagopa-d-itn-portalpa-departements-rg"
    prod_deploy_type                 = "staging_slot_and_swap" # deploy to staging then swap
    prod_azure_subscription          = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name
    prod_web_app_name                = "pagopa-p-itn-portalpa-app"
    prod_web_app_resource_group_name = "pagopa-p-itn-portalpa-departements-rg"

    # Key Vault (used by pipeline to fetch DATABASE_URL at runtime)
    dev_key_vault_name  = local.dev_centralhub_key_vault_name
    prod_key_vault_name = local.prod_centralhub_key_vault_name

    # ACR — Italy North workload identity
    image_repository                     = "pagopa-portal"
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.service_endpoint_name
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.service_endpoint_name

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"
  }

  # deploy secrets
  pagopa-portalpa-variables_secret_deploy = {}
}

module "pagopa-portalpa_code_review" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_code_review"
  count  = var.pagopa-portalpa.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-portalpa.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.service_endpoint_id
  path                         = "${local.domain}\\pagopa-portalpa"

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.pagopa-portalpa-variables,
    local.pagopa-portalpa-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-portalpa-variables_secret,
    local.pagopa-portalpa-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}

module "pagopa-portalpa_deploy" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_deploy"
  count  = var.pagopa-portalpa.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-portalpa.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-portalpa"

  variables = merge(
    local.pagopa-portalpa-variables,
    local.pagopa-portalpa-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-portalpa-variables_secret,
    local.pagopa-portalpa-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
    data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.id,
  ]
}
