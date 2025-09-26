##################################################
#         DO NOT COPY-PASTE THIS FILE
# use the new structured way to define the iac pipelines
# have a look at README.md
##################################################
variable "crusc8_iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-cruscotto-backend"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "cruscotto"
    }
    pipeline = {
      path = "crusc8-infrastructure"
      db_schema = {
        name                  = "cruscotto-db-users-schema-pipelines.yml"
        pipeline_yml_filename = "cruscotto-db-users-schema-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  crusc8_iac_variables = {
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
  crusc8_iac_variables_secret = {}

  # code_review vars
  crusc8_iac_variables_code_review = {}
  # code_review secrets
  crusc8_iac_variables_secret_code_review = {}

  # deploy vars
  crusc8_iac_variables_deploy = {}
  # deploy secrets
  crusc8_iac_variables_secret_deploy = {}

  # db-schema vars
  crusc8_iac_variables_db_schema = {}
  # db-schema secrets
  crusc8_iac_variables_secret_db_schema = {}

}

module "crusc8_iac_db_schema" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.0.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.crusc8_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.crusc8_iac.pipeline.path
  pipeline_name                = var.crusc8_iac.pipeline.db_schema.name
  pipeline_yml_filename        = var.crusc8_iac.pipeline.db_schema.pipeline_yml_filename

  variables = merge(
    local.crusc8_iac_variables,
    local.crusc8_iac_variables_db_schema,
  )

  variables_secret = merge(
    local.crusc8_iac_variables_secret_db_schema,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}
