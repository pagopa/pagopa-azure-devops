variable "fdr_iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "fdr"
    }
    pipeline = {
      enable_code_review   = true
      enable_deploy        = true
      path                 = "fdr-infrastructure"
      pipeline_name_prefix = "fdr-infra"
      db_migration = {
        name                  = "fdr-db-migration-pipelines"
        pipeline_yml_filename = "fdr-db-migration-pipelines.yml"
      }
      db_schema = {
        name                  = "fdr-db-schema-pipelines"
        pipeline_yml_filename = "fdr-db-schema-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  fdr_iac_variables = {
    tf_dev_aks_apiserver_url         = module.fdr_dev_secrets.values["pagopa-d-weu-dev-aks-apiserver-url"].value,
    tf_dev_aks_azure_devops_sa_cacrt = module.fdr_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-cacrt"].value,
    tf_dev_aks_azure_devops_sa_token = base64decode(module.fdr_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-token"].value),
    tf_aks_dev_name                  = var.aks_dev_platform_name
    tf_dev_azure_service_connection  = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name

    tf_uat_aks_apiserver_url         = module.fdr_uat_secrets.values["pagopa-u-weu-uat-aks-apiserver-url"].value,
    tf_uat_aks_azure_devops_sa_cacrt = module.fdr_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-cacrt"].value,
    tf_uat_aks_azure_devops_sa_token = base64decode(module.fdr_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-token"].value),
    tf_aks_uat_name                  = var.aks_uat_platform_name
    tf_uat_azure_service_connection  = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name

    # tf_prod_aks_apiserver_url         = module.fdr_prod_secrets.values["pagopa-p-weu-prod-aks-apiserver-url"].value,
    # tf_prod_aks_azure_devops_sa_cacrt = module.fdr_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value,
    # tf_prod_aks_azure_devops_sa_token = base64decode(module.fdr_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-token"].value),
    # tf_aks_prod_name                  = var.aks_prod_platform_name
    # tf_prod_azure_service_connection  = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
  }
  # global secrets
  fdr_iac_variables_secret = {}

  # code_review vars
  fdr_iac_variables_code_review = {}
  # code_review secrets
  fdr_iac_variables_secret_code_review = {}

  # deploy vars
  fdr_iac_variables_deploy = {}
  # deploy secrets
  fdr_iac_variables_secret_deploy = {}

  # db-migration vars
  fdr_iac_variables_db_migration = {}
  # db-migration secrets
  fdr_iac_variables_secret_db_migration = {}

  # db-schema vars
  fdr_iac_variables_db_schema = {}
  # db-schema secrets
  fdr_iac_variables_secret_db_schema = {}

}


# fdr infra (PLAN+APPLY ) & db creation+migration
module "fdr_iac_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.2.0"
  count  = var.fdr_iac.pipeline.enable_code_review == true ? 1 : 0
  path   = var.fdr_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.fdr_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.fdr_iac.pipeline.pipeline_name_prefix

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.fdr_iac_variables,
    local.fdr_iac_variables_code_review,
  )

  variables_secret = merge(
    local.fdr_iac_variables_secret,
    local.fdr_iac_variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}

module "fdr_iac_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v5.2.0"
  count  = var.fdr_iac.pipeline.enable_deploy == true ? 1 : 0
  path   = var.fdr_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.fdr_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.fdr_iac.pipeline.pipeline_name_prefix

  ci_trigger_use_yaml           = false
  pull_request_trigger_use_yaml = false

  variables = merge(
    local.fdr_iac_variables,
    local.fdr_iac_variables_deploy,
  )

  variables_secret = merge(
    local.fdr_iac_variables_secret,
    local.fdr_iac_variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}

module "fdr_iac_db_migration" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v5.2.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.fdr_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.fdr_iac.pipeline.path
  pipeline_name                = var.fdr_iac.pipeline.db_migration.name
  pipeline_yml_filename        = var.fdr_iac.pipeline.db_migration.pipeline_yml_filename

  variables = merge(
    local.fdr_iac_variables,
    local.fdr_iac_variables_db_migration,
  )

  variables_secret = merge(
    local.fdr_iac_variables_secret_db_migration,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}

module "fdr_iac_db_schema" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v5.2.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.fdr_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.fdr_iac.pipeline.path
  pipeline_name                = var.fdr_iac.pipeline.db_schema.name
  pipeline_yml_filename        = var.fdr_iac.pipeline.db_schema.pipeline_yml_filename

  variables = merge(
    local.fdr_iac_variables,
    local.fdr_iac_variables_db_schema,
  )

  variables_secret = merge(
    local.fdr_iac_variables_secret_db_schema,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
