variable "pagopa-platform-cdn-assets" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-platform-cdn-assets"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pagopa"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
    }
  }
}

locals {
  # global vars
  pagopa-platform-cdn-assets-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-platform-cdn-assets.repository.branch_name
  }
  # global secrets
  pagopa-platform-cdn-assets-variables_secret = {

  }
  # code_review vars
  pagopa-platform-cdn-assets-variables_code_review = {

  }
  # code_review secrets
  pagopa-platform-cdn-assets-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-platform-cdn-assets-variables_deploy = {
    cache_version_id          = "v1"
    prod_storage_account_name = "pagopapassetsplatformsa"
    prod_profile_cdn_name     = "pagopa-p-assets-platform-cdn-profile"
    prod_endpoint_name        = "pagopa-p-assets-platform-cdn-endpoint "
    prod_resource_group_name  = "pagopa-p-assets-cdn-platform-rg"
    prod_blob_container_name  = "$web"
    prod_azure_subscription   = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
  }
  # deploy secrets
  pagopa-platform-cdn-assets-variables_secret_deploy = {
    git_mail               = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username           = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection      = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    prod_azure_storage_key = module.secrets.values["assets-azure-storage-key"].value
  }
}

# module "pagopa-platform-cdn-assets_code_review" {
#   source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
#   count  = var.pagopa-platform-cdn-assets.pipeline.enable_code_review == true ? 1 : 0

#   project_id                   = azuredevops_project.project.id
#   repository                   = var.pagopa-platform-cdn-assets.repository
#   github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

#   variables = merge(
#     local.pagopa-platform-cdn-assets-variables,
#     local.pagopa-platform-cdn-assets-variables_code_review,
#   )

#   variables_secret = merge(
#     local.pagopa-platform-cdn-assets-variables_secret,
#     local.pagopa-platform-cdn-assets-variables_secret_code_review,
#   )

#   service_connection_ids_authorization = [
#     azuredevops_serviceendpoint_github.azure-devops-github-ro.id
#   ]
# }

module "pagopa-platform-cdn-assets_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-platform-cdn-assets.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-platform-cdn-assets.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-platform-cdn-assets-variables,
    local.pagopa-platform-cdn-assets-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-platform-cdn-assets-variables_secret,
    local.pagopa-platform-cdn-assets-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
