locals {
  prefix           = "pagopa"
  azure_devops_org = "pagopaspa"
  domain           = "centralhub"

  dev_subscription_name  = "dev-pagopa"
  uat_subscription_name  = "uat-pagopa"
  prod_subscription_name = "prod-pagopa"

  location_short = "itn"

  # 🔐 KV azdo (shared)
  prod_key_vault_azdo_name      = "${local.prefix}-p-azdo-weu-kv"
  prod_key_vault_resource_group = "${local.prefix}-p-sec-rg"

  # 🔐 KV DOMAIN
  dev_centralhub_key_vault_name  = "${local.prefix}-d-${local.location_short}-portalpa-kv"
  prod_centralhub_key_vault_name = "${local.prefix}-p-${local.location_short}-portalpa-kv"

  dev_centralhub_key_vault_resource_group  = "${local.prefix}-d-${local.location_short}-portalpa-sec-rg"
  prod_centralhub_key_vault_resource_group = "${local.prefix}-p-${local.location_short}-portalpa-sec-rg"

  # KV (hosts the domain-level GitHub PAT for Central Hub service connection)
  prod_centralhub_github_kv_name      = local.prod_centralhub_key_vault_name
  prod_centralhub_github_kv_rg        = local.prod_centralhub_key_vault_resource_group
  centralhub_github_token_secret_name = "azure-devops-centralhub-github-token"

  # Environments used to bootstrap the GitHub PAT retrieval.
  centralhub_bootstrap_envs = ["prod"]
  centralhub_environment_secrets = {
    prod = {
      key_vault_name           = local.prod_centralhub_github_kv_name
      key_vault_resource_group = local.prod_centralhub_github_kv_rg
    }
  }

  # Dedicated service connection name created by this domain state
  centralhub_github_connection_name = "centralhub-azure-devops-github"

  centralhub_repository = {
    organization    = "pagopa"
    name            = "pagopa-payments-department-centralhub"
    branch_name     = "refs/heads/main"
    pipelines_path  = ".devops"
    yml_prefix_name = null
  }

  centralhub_base_variables = {
    cache_version_id  = "v1"
    default_branch    = "refs/heads/main"
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    github_connection = local.centralhub_github_connection_name
  }

  centralhub_applications = {
    portalpa = {
      repository         = local.centralhub_repository
      path               = "${local.domain}\\pagopa-portalpa"
      pipeline_prefix    = "pagopa-portalpa"
      enable_code_review = true
      enable_deploy      = true

      code_review = {
        variables = {
          danger_github_api_token = "skip"
        }
      }

      deploy = {
        variables = {
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

        service_connection_ids_authorization = [
          data.azuredevops_serviceendpoint_azurerm.dev.id,
          data.azuredevops_serviceendpoint_azurerm.prod.id,
          data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.id,
          data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.id,
        ]

        queue_ids_to_authorize = [
          data.azuredevops_agent_queue.uat_linux.id,
          data.azuredevops_agent_queue.prod_linux.id,
        ]
      }
    }
  }
}
