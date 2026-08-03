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
      envs            = ["d", "u", "p"]
      kv_name         = "${local.prefix}-%s-itn-qa-kv"
      rg_name         = "${local.prefix}-%s-itn-qa-sec-rg"
      region          = "itn"
      code_review     = true
      deploy          = true
      pipeline_prefix = "pagopa-qa-centralhub-frontend"
      pipeline_path   = "${local.domain}\\pagopa-qa-centralhub-frontend"
      secrets         = ["nextauth-secret", "google-client-id", "google-client-secret"]
      repository = {
        organization    = "pagopa"
        name            = "pagopa-qa-centralhub-frontend"
        branch_name     = "refs/heads/main"
        pipelines_path  = "azure-pipelines"
        yml_prefix_name = null
      }
    }
  ]

  deploy_pipelines      = [for p in local.app_pipelines : p if p.deploy]
  code_review_pipelines = [for p in local.app_pipelines : p if p.code_review]

  # Variables shared by every application pipeline (non-secret).
  base_app_variables = {
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
    git_email    = module.secrets.values["azure-devops-github-EMAIL"].value
    github_conn  = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
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
        dev_nextauth_url                    = "https://api.dev.platform.pagopa.it/qa/central-hub/v1" # NextAuth base url, not secret

        # UAT
        uat_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
        uat_web_app_name                    = "pagopa-u-itn-qa-qa-hub-wa"
        uat_web_app_resource_group_name     = "pagopa-u-itn-qa-qa-hub-rg"
        uat_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.service_endpoint_name
        uat_container_namespace             = "pagopauitncoreacr.azurecr.io"
        uat_next_public_api_url             = "https://api.uat.platform.pagopa.it/qa/central-hub/v1"
        uat_nextauth_url                    = "https://api.uat.platform.pagopa.it/qa/central-hub/v1" # NextAuth base url, not secret

        # PROD
        prod_azure_subscription              = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name
        prod_web_app_name                    = "pagopa-p-itn-qa-qa-hub-wa"
        prod_web_app_resource_group_name     = "pagopa-p-itn-qa-qa-hub-rg"
        prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.service_endpoint_name
        prod_container_namespace             = "pagopapitncoreacr.azurecr.io"
        prod_next_public_api_url             = "https://api.platform.pagopa.it/qa/central-hub/v1"
        prod_nextauth_url                    = "https://api.platform.pagopa.it/qa/central-hub/v1" # NextAuth base url, not secret
      }
      variables_secrets_deploy = {
        dev_nextauth_secret      = module.qa_dev_secrets["centralhub-fe"].values["nextauth-secret"].value
        dev_google_client_id     = module.qa_dev_secrets["centralhub-fe"].values["google-client-id"].value
        dev_google_client_secret = module.qa_dev_secrets["centralhub-fe"].values["google-client-secret"].value

        uat_nextauth_secret      = module.qa_uat_secrets["centralhub-fe"].values["nextauth-secret"].value
        uat_google_client_id     = module.qa_uat_secrets["centralhub-fe"].values["google-client-id"].value
        uat_google_client_secret = module.qa_uat_secrets["centralhub-fe"].values["google-client-secret"].value

        prod_nextauth_secret      = module.qa_prod_secrets["centralhub-fe"].values["nextauth-secret"].value
        prod_google_client_id     = module.qa_prod_secrets["centralhub-fe"].values["google-client-id"].value
        prod_google_client_secret = module.qa_prod_secrets["centralhub-fe"].values["google-client-secret"].value
      }
      # code review (PR gate) — lint/type-check/test/build run in the repo YAML
      variables_cr         = {}
      variables_secrets_cr = {}
    }
  }
}
