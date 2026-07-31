variable "pagopa-qa-centralhub-fe" {
  default = {
    repository = {
      organization = "pagopa"
      name         = "pagopa-qa-centralhub-frontend"
      branch_name  = "refs/heads/main"
      # the deploy module targets `<pipelines_path>/<yml_prefix_name->deploy-pipelines.yml`
      pipelines_path  = "azure-pipelines"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = false
      enable_deploy      = true
    }
  }
}

locals {
  # global vars (non-secret, not environment-specific)
  pagopa-qa-centralhub-fe-variables = {
    # ⚠️ image name must match the repo value used by the pipeline (with dashes)
    image_repository = "pagopa-qa-centralhub-fe"
    # ⚠️ pipeline uses a dedicated GitHub connection "github-pat-qa-hub"; here we
    # wire the shared RW connection. Switch if a dedicated PAT connection is required.
    github_conn  = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
    git_email    = module.secrets.values["azure-devops-github-EMAIL"].value
  }
  # global secrets
  pagopa-qa-centralhub-fe-variables_secret = {
  }
  # deploy vars (ITN - Italy North, aligned with the ITN web apps)
  pagopa-qa-centralhub-fe-variables_deploy = {
    # DEV
    dev_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    dev_web_app_name                    = "pagopa-d-itn-qa-qa-hub-wa"
    dev_web_app_resource_group_name     = "pagopa-d-itn-qa-qa-hub-rg"
    dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.service_endpoint_name
    dev_container_namespace             = "pagopaditncoreacr.azurecr.io"
    dev_next_public_api_url             = "TODO" # public API base url (build-arg), not secret
    dev_nextauth_url                    = "TODO" # NextAuth base url, not secret

    # UAT
    uat_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    uat_web_app_name                    = "pagopa-u-itn-qa-qa-hub-wa"
    uat_web_app_resource_group_name     = "pagopa-u-itn-qa-qa-hub-rg"
    uat_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.service_endpoint_name
    uat_container_namespace             = "pagopauitncoreacr.azurecr.io"
    uat_next_public_api_url             = "TODO"
    uat_nextauth_url                    = "TODO"

    # PROD
    prod_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name
    prod_web_app_name                    = "pagopa-p-itn-qa-qa-hub-wa"
    prod_web_app_resource_group_name     = "pagopa-p-itn-qa-qa-hub-rg"
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.service_endpoint_name
    prod_container_namespace             = "pagopapitncoreacr.azurecr.io"
    prod_next_public_api_url             = "TODO"
    prod_nextauth_url                    = "TODO"
  }
  # deploy secrets (OAuth/NextAuth, read from the per-env QA key vaults)
  pagopa-qa-centralhub-fe-variables_secret_deploy = {
    dev_nextauth_secret      = module.qa_dev_secrets.values["nextauth-secret"].value
    dev_google_client_id     = module.qa_dev_secrets.values["google-client-id"].value
    dev_google_client_secret = module.qa_dev_secrets.values["google-client-secret"].value

    uat_nextauth_secret      = module.qa_uat_secrets.values["nextauth-secret"].value
    uat_google_client_id     = module.qa_uat_secrets.values["google-client-id"].value
    uat_google_client_secret = module.qa_uat_secrets.values["google-client-secret"].value

    prod_nextauth_secret      = module.qa_prod_secrets.values["nextauth-secret"].value
    prod_google_client_id     = module.qa_prod_secrets.values["google-client-id"].value
    prod_google_client_secret = module.qa_prod_secrets.values["google-client-secret"].value
  }
}

module "pagopa-qa-centralhub-fe_deploy" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_deploy"
  count  = var.pagopa-qa-centralhub-fe.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-qa-centralhub-fe.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.id
  path                         = "${local.domain}\\${var.pagopa-qa-centralhub-fe.repository.name}"

  variables = merge(
    local.pagopa-qa-centralhub-fe-variables,
    local.pagopa-qa-centralhub-fe-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-qa-centralhub-fe-variables_secret,
    local.pagopa-qa-centralhub-fe-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
    data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.id,
  ]
}
