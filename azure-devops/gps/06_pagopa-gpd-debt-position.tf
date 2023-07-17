variable "pagopa-debt-position" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-debt-position"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_deploy      = true
      performance_test = {
        enabled               = true
        name                  = "performance-test-gpd-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-debt-position-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-debt-position.repository.branch_name
  }
  # global secrets
  pagopa-debt-position-variables_secret = {

  }
  # deploy vars
  pagopa-debt-position-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name

    dev_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name

    healthcheck_endpoint = "/api/v1/info"
    dev_web_app_name     = "pagopa-d"
    uat_web_app_name     = "pagopa-u"
    prod_web_app_name    = "pagopa-p"

    tenant_id = module.secrets.values["TENANTID"].value

    # acr section
    image_repository = "debt-position"

    dev_container_registry  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    prod_container_registry = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    # datasource4flyway
    DEV_POSTGRES_DATASOURCE_USERNAME  = "apduser@pagopa-d-postgresql"
    UAT_POSTGRES_DATASOURCE_USERNAME  = "apduser"
    PROD_POSTGRES_DATASOURCE_USERNAME = "apduser"

    DEV_POSTGRES_DATASOURCE_PASSWORD  = module.secrets.values["DEV-APD-SPRING-DATASOURCE-PWD"].value
    UAT_POSTGRES_DATASOURCE_PASSWORD  = module.secrets.values["UAT-APD-SPRING-DATASOURCE-PWD"].value
    PROD_POSTGRES_DATASOURCE_PASSWORD = module.secrets.values["PROD-APD-SPRING-DATASOURCE-PWD"].value

    DEV_POSTGRES_DATASOURCE_URL  = format("jdbc:postgresql://%s:5432/%s", "pagopa-d-postgresql.postgres.database.azure.com", "apd")
    UAT_POSTGRES_DATASOURCE_URL  = format("jdbc:postgresql://%s:5432/%s?sslmode=require", "pagopa-u-gpd-pgflex.postgres.database.azure.com", "apd")
    PROD_POSTGRES_DATASOURCE_URL = format("jdbc:postgresql://%s:5432/%s?sslmode=require", "pagopa-p-gpd-pgflex.postgres.database.azure.com", "apd")

    SCHEMA_NAME = "apd"

    DEV_NODO_HOST  = "https://api.dev.platform.pagopa.it/nodo/nodo-per-pa/v1/"
    UAT_NODO_HOST  = "https://api.uat.platform.pagopa.it/nodo/nodo-per-pa/v1/"
    PROD_NODO_HOST = "https://api.platform.pagopa.it/nodo/nodo-per-pa/v1/"
  }
  # deploy secrets
  pagopa-debt-position-variables_secret_deploy = {
    DEV_API_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-api-subscription-key"].value
    UAT_API_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-api-subscription-key"].value
  }

  ## Performance Test Pipeline vars and secrets ##

  # performance vars
  pagopa-debt-position-variables_performance_test = {
  }
  # performance secrets
  pagopa-debt-position-variables_secret_performance_test = {
    DEV_API_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-api-subscription-key"].value
    UAT_API_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-api-subscription-key"].value
  }
}

module "pagopa-debt-position_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-debt-position.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-debt-position.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-gpd-core"

  variables = merge(
    local.pagopa-debt-position-variables,
    local.pagopa-debt-position-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-debt-position-variables_secret,
    local.pagopa-debt-position-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}

module "pagopa-debt-position_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v2.6.3"
  count  = var.pagopa-debt-position.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-debt-position.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-gpd-core"
  pipeline_name                = var.pagopa-debt-position.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-debt-position.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-debt-position-variables,
    local.pagopa-debt-position-variables_performance_test
  )

  variables_secret = merge(
    local.pagopa-debt-position-variables_secret,
    local.pagopa-debt-position-variables_secret_performance_test
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}
