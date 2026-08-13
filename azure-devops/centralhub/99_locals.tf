locals {
  app_pipelines = [
    {
      name            = "portalpa"
      envs            = ["d", "p"]
      code_review     = true
      deploy          = true
      pipeline_prefix = "pagopa-portalpa"
      pipeline_path   = "${local.domain}\\pagopa-portalpa"
      repository = {
        organization    = "pagopa"
        name            = "pagopa-payments-department-centralhub"
        branch_name     = "refs/heads/main"
        pipelines_path  = ".devops"
        yml_prefix_name = null
      }
    }
  ]

  deploy_pipelines      = [for p in local.app_pipelines : p if p.deploy]
  code_review_pipelines = [for p in local.app_pipelines : p if p.code_review]

  base_app_variables = {
    cache_version_id  = "v1"
    default_branch    = "refs/heads/main"
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    github_connection = azuredevops_serviceendpoint_github.github_centralhub.service_endpoint_name
  }

  pipelines_variables = {
    portalpa = {
      variables_deploy = {
        image_repository = "pagopa-portal"

        dev_deploy_type                     = "production_slot"
        dev_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
        dev_web_app_name                    = "pagopa-d-itn-portalpa-app"
        dev_web_app_resource_group_name     = "pagopa-d-itn-portalpa-departements-rg"
        dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.service_endpoint_name
        dev_container_namespace             = "pagopadcommonacr.azurecr.io"
        dev_key_vault_name                  = local.dev_centralhub_key_vault_name

        prod_deploy_type                     = "staging_slot_and_swap"
        prod_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name
        prod_web_app_name                    = "pagopa-p-itn-portalpa-app"
        prod_web_app_resource_group_name     = "pagopa-p-itn-portalpa-departements-rg"
        prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.service_endpoint_name
        prod_container_namespace             = "pagopapcommonacr.azurecr.io"
        prod_key_vault_name                  = local.prod_centralhub_key_vault_name
      }
      variables_secrets_deploy = {}
      variables_cr = {
        danger_github_api_token = "skip"
      }
      variables_secrets_cr = {}
    }
  }
}
