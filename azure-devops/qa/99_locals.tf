##################################################
# HOW TO ADD A NEW APPLICATION PIPELINE?
#
# 1. add an entry to `local.app_pipelines` (config of the pipeline);
# 2. add its variables/secrets to `local.pipelines_variables[<name>]`;
# 3. terraform apply.
#
# Modelled on the config-driven approach used in azure-devops/iac, but wired
# with the application service connections (AzureRM + ACR ITA) and the domain
# key vaults, instead of the IaC plan/apply ones.
##################################################

locals {
  app_pipelines = [
    {
      name            = "centralhub-fe"
      envs            = ["d", "u"]
      kv_name         = "${local.prefix}-%s-itn-qa-kv"
      rg_name         = "${local.prefix}-%s-itn-qa-sec-rg"
      region          = "itn"
      code_review     = true
      deploy          = true
      pipeline_prefix = "pagopa-qa-centralhub-frontend"
      pipeline_path   = "${local.domain}\\pagopa-qa-centralhub-frontend"
      secrets         = []
      repository = {
        organization    = "pagopa"
        name            = "pagopa-qa-centralhub-frontend"
        branch_name     = "refs/heads/main"
        pipelines_path  = "azure-pipelines"
        yml_prefix_name = null
      },
    },
    {
      name            = "qa-superset"
      envs            = ["d", "u", "p"]
      kv_name         = "${local.prefix}-%s-itn-qa-kv"
      rg_name         = "${local.prefix}-%s-itn-qa-sec-rg"
      region          = "itn"
      code_review     = true
      deploy          = true
      pipeline_prefix = "pagopa-qa-superset"
      pipeline_path   = "${local.domain}\\pagopa-qa-superset"
      secrets         = []
      repository = {
        organization    = "pagopa"
        name            = "pagopa-qa-superset"
        branch_name     = "refs/heads/helm"
        pipelines_path  = ".devops"
        yml_prefix_name = null
      }
    }
  ]

  env_configurations = {
    dev = {
      subscription_name                   = local.dev_subscription_name
      subscription_id                     = local.dev_subscription_id
      credential_key_vault_name           = local.dev_kv_domain_name
      credential_key_vault_resource_group = local.dev_kv_domain_resource_group
      service_endpoint_id                 = module.dev_tls_cert_service_connection.service_endpoint_id
      variables = {
        KEY_VAULT_SERVICE_CONNECTION = module.dev_tls_cert_service_connection.service_endpoint_name
      }
      variables_secret = {}
    }
  }

  deploy_pipelines      = [for p in local.app_pipelines : p if p.deploy]
  code_review_pipelines = [for p in local.app_pipelines : p if p.code_review]

  # Variables shared by every application pipeline (non-secret).
  base_app_variables = {
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
    git_email    = module.secrets.values["azure-devops-github-EMAIL"].value
    github_conn  = azuredevops_serviceendpoint_github.github_qa.service_endpoint_name
  }

  # Per-pipeline variables and secrets (merged onto base_app_variables).
  pipelines_variables = {
    centralhub-fe = {
      variables_deploy = {
        # ⚠️ image name must match the repo value used by the pipeline (with dashes)
        image_repository = "pagopa-qa-centralhub-fe"

        # DEV
        dev_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
        dev_web_app_name                    = "pagopa-d-itn-qa-qa-hub-wa"
        dev_web_app_resource_group_name     = "pagopa-d-itn-qa-qa-hub-rg"
        dev_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.service_endpoint_name
        dev_container_namespace             = "pagopaditncoreacr.azurecr.io"
        dev_next_public_api_url             = "https://api.dev.platform.pagopa.it/qa/central-hub/v1" # public API base url (build-arg), not secret
        dev_nextauth_url                    = "https://pagopa-d-itn-qa-qa-hub-wa.azurewebsites.net"  # NextAuth base url, not secret

        # UAT
        uat_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
        uat_web_app_name                    = "pagopa-u-itn-qa-qa-hub-wa"
        uat_web_app_resource_group_name     = "pagopa-u-itn-qa-qa-hub-rg"
        uat_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.service_endpoint_name
        uat_container_namespace             = "pagopauitncoreacr.azurecr.io"
        uat_next_public_api_url             = "https://api.uat.platform.pagopa.it/qa/central-hub/v1"
        uat_nextauth_url                    = "https://pagopa-u-itn-qa-qa-hub-wa.azurewebsites.net" # NextAuth base url, not secret

        # PROD
        prod_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name
        prod_web_app_name                    = "pagopa-p-itn-qa-qa-hub-wa"
        prod_web_app_resource_group_name     = "pagopa-p-itn-qa-qa-hub-rg"
        prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.service_endpoint_name
        prod_container_namespace             = "pagopapitncoreacr.azurecr.io"
        prod_next_public_api_url             = "https://api.platform.pagopa.it/qa/central-hub/v1"
        prod_nextauth_url                    = "https://api.platform.pagopa.it/qa/central-hub/v1" # NextAuth base url, not secret
      }
      variables_secrets_deploy = {}
      # code review (PR gate) — lint/type-check/test/build run in the repo YAML
      variables_cr         = {}
      variables_secrets_cr = {}
    }
    qa-superset = {
      variables_deploy = {
        # DEV
        dev_azure_subscription     = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_id
        dev_container_namespace    = "pagopaditncoreacr.azurecr.io"
        dev_aks_service_connection = azuredevops_serviceendpoint_kubernetes.aks_dev.service_endpoint_name

        uat_azure_subscription     = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_id
        uat_container_namespace    = "pagopauitncoreacr.azurecr.io"
        uat_aks_service_connection = azuredevops_serviceendpoint_kubernetes.aks_uat.service_endpoint_name

        # prod_azure_subscription     = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_id
        # prod_container_namespace    = "pagopapitncoreacr.azurecr.io"
        # prod_aks_service_connection = azuredevops_serviceendpoint_kubernetes.aks_prod.service_endpoint_name
      }
    }
  }
}
