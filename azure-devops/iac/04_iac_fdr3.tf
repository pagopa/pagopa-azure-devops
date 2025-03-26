variable "fdr3_iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-fdr"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "fdr-fase3"
    }
    pipeline = {
      path                 = "fdr3-infrastructure"
      db_migration = {
        name                  = "fdr-fase3-db-migration-pipelines"
        pipeline_yml_filename = "fdr-fase3-db-migration-pipelines.yml"
      }
      db_schema = {
        name                  = "fdr-fase3-db-schema-pipelines"
        pipeline_yml_filename = "fdr-fase3-db-schema-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  fdr3_iac_variables = {
    TF_POOL_NAME_DEV  = "pagopa-dev-linux-infra",
    TF_POOL_NAME_UAT  = "pagopa-uat-linux-infra",
    TF_POOL_NAME_PROD = "pagopa-prod-linux-infra",
    #PLAN
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV  = module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_UAT  = module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_PROD = module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,

    #APPLY
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV  = module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT  = module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD = module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
  }
  # global secrets
  fdr3_iac_variables_secret = {}

  # code_review vars
  fdr3_iac_variables_code_review = {}
  # code_review secrets
  fdr3_iac_variables_secret_code_review = {}

  # deploy vars
  fdr3_iac_variables_deploy = {}
  # deploy secrets
  fdr3_iac_variables_secret_deploy = {}

  # db-migration vars
  fdr3_iac_variables_db_migration = {}
  # db-migration secrets
  fdr3_iac_variables_secret_db_migration = {}

  # db-schema vars
  fdr3_iac_variables_db_schema = {}
  # db-schema secrets
  fdr3_iac_variables_secret_db_schema = {}

}

module "fdr3_iac_db_migration" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.0.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.fdr3_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.fdr3_iac.pipeline.path
  pipeline_name                = var.fdr3_iac.pipeline.db_migration.name
  pipeline_yml_filename        = var.fdr3_iac.pipeline.db_migration.pipeline_yml_filename

  variables = merge(
    local.fdr3_iac_variables,
    local.fdr3_iac_variables_db_migration,
  )

  variables_secret = merge(
    local.fdr3_iac_variables_secret_db_migration,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "fdr3_iac_db_schema" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.0.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.fdr3_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.fdr3_iac.pipeline.path
  pipeline_name                = var.fdr3_iac.pipeline.db_schema.name
  pipeline_yml_filename        = var.fdr3_iac.pipeline.db_schema.pipeline_yml_filename

  variables = merge(
    local.fdr3_iac_variables,
    local.fdr3_iac_variables_db_schema,
  )

  variables_secret = merge(
    local.fdr3_iac_variables_secret_db_schema,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}
