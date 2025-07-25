##################################################
#         DO NOT COPY-PASTE THIS FILE
# use the new structured way to define the iac pipelines
# have a look at README.md
##################################################
variable "nodo_iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "nodo"
    }
    pipeline = {
      enable_code_review   = true
      enable_deploy        = true
      path                 = "nodo-infrastructure"
      pipeline_name_prefix = "nodo-infra"
      db_migration = {
        name                  = "nodo-db-migration-pipelines"
        pipeline_yml_filename = "nodo-db-migration-pipelines.yml"
      }
      db_schema = {
        name                  = "nodo-db-schema-pipelines"
        pipeline_yml_filename = "nodo-db-schema-pipelines.yml"
      }
      db_partitioned_data_migration = {
        name                  = "nodo-partitioned-db-data-migration-pipelines"
        pipeline_yml_filename = "nodo-partitioned-db-data-migration-pipelines.yml"
      }
      web_bo_db_migration = {
        name                  = "web-bo-db-migration-pipelines"
        pipeline_yml_filename = "web-bo-db-migration-pipelines.yml"
      }
      web_bo_db_schema = {
        name                  = "web-bo-db-schema-pipelines"
        pipeline_yml_filename = "web-bo-db-schema-pipelines.yml"
      }
      sync_schema_cfg_grant = {
        name                  = "sync-schema-cfg-grant-pipelines"
        pipeline_yml_filename = "nodo-sync-grant-schema-cfg-pipelines.yml"
      }
      nodo_cron_alert_suspend_jobs = {
        name                  = "nodo-cron-alert-suspend-jobs-pipelines"
        pipeline_yml_filename = "nodo-cron-alert-suspend-jobs-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  nodo_iac_variables = {
    tf_dev_aks_apiserver_url         = module.nodo_dev_secrets.values["pagopa-d-weu-dev-aks-apiserver-url"].value,
    tf_dev_aks_azure_devops_sa_cacrt = module.nodo_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-cacrt"].value,
    tf_dev_aks_azure_devops_sa_token = base64decode(module.nodo_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-token"].value),
    tf_aks_dev_name                  = var.aks_dev_platform_name

    tf_uat_aks_apiserver_url         = module.nodo_uat_secrets.values["pagopa-u-weu-uat-aks-apiserver-url"].value,
    tf_uat_aks_azure_devops_sa_cacrt = module.nodo_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-cacrt"].value,
    tf_uat_aks_azure_devops_sa_token = base64decode(module.nodo_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-token"].value),
    tf_aks_uat_name                  = var.aks_uat_platform_name

    tf_prod_aks_apiserver_url         = module.nodo_prod_secrets.values["pagopa-p-weu-prod-aks-apiserver-url"].value,
    tf_prod_aks_azure_devops_sa_cacrt = module.nodo_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value,
    tf_prod_aks_azure_devops_sa_token = base64decode(module.nodo_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-token"].value),
    tf_aks_prod_name                  = var.aks_prod_platform_name

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
  nodo_iac_variables_secret = {}

  # code_review vars
  nodo_iac_variables_code_review = {}
  # code_review secrets
  nodo_iac_variables_secret_code_review = {}

  # deploy vars
  nodo_iac_variables_deploy = {}
  # deploy secrets
  nodo_iac_variables_secret_deploy = {}

  # db-migration vars
  nodo_iac_variables_db_migration = {}
  # db-migration secrets
  nodo_iac_variables_secret_db_migration = {}

  # db-schema vars
  nodo_iac_variables_db_schema = {}
  # db-schema secrets
  nodo_iac_variables_secret_db_schema = {}

  # db-partitioned-data-migration vars
  nodo_iac_variables_db_partitioned_data_migration = {}
  # db-partitioned-data-migration secrets
  nodo_iac_variables_secret_db_partitioned_data_migration = {}

  # db-web-bo-migration vars
  nodo_iac_variables_web_bo_db_migration = {}
  # db-web-bo-migration secrets
  nodo_iac_variables_secret_web_bo_db_migration = {}

  # db-web-bo-schema vars
  nodo_iac_variables_web_bo_db_schema = {}
  # db-web-bo-schema secrets
  nodo_iac_variables_secret_web_bo_db_schema = {}

  # nodo-cron-alert-suspend-jobs variables
  nodo_iac_variables_cron_alert_suspend_jobs = {}
  # nodo-cron-alert-suspend-jobs secrets
  nodo_iac_variables_secret_cron_alert_suspend_jobs = {}
}


# NODO infra (PLAN+APPLY ) & db creation+migration
module "nodo_iac_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v7.0.0"
  count  = var.nodo_iac.pipeline.enable_code_review == true ? 1 : 0
  path   = var.nodo_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.nodo_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.nodo_iac.pipeline.pipeline_name_prefix

  variables = merge(
    local.nodo_iac_variables,
    local.nodo_iac_variables_code_review,
  )

  variables_secret = merge(
    local.nodo_iac_variables_secret,
    local.nodo_iac_variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "nodo_iac_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v7.0.0"
  count  = var.nodo_iac.pipeline.enable_deploy == true ? 1 : 0
  path   = var.nodo_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.nodo_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.nodo_iac.pipeline.pipeline_name_prefix

  variables = merge(
    local.nodo_iac_variables,
    local.nodo_iac_variables_deploy,
  )

  variables_secret = merge(
    local.nodo_iac_variables_secret,
    local.nodo_iac_variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,

    module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
  ]
}

module "nodo_iac_db_migration" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.0.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.nodo_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.nodo_iac.pipeline.path
  pipeline_name                = var.nodo_iac.pipeline.db_migration.name
  pipeline_yml_filename        = var.nodo_iac.pipeline.db_migration.pipeline_yml_filename

  variables = merge(
    local.nodo_iac_variables,
    local.nodo_iac_variables_db_migration,
  )

  variables_secret = merge(
    local.nodo_iac_variables_secret_db_migration,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "nodo_iac_db_schema" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.0.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.nodo_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.nodo_iac.pipeline.path
  pipeline_name                = var.nodo_iac.pipeline.db_schema.name
  pipeline_yml_filename        = var.nodo_iac.pipeline.db_schema.pipeline_yml_filename

  variables = merge(
    local.nodo_iac_variables,
    local.nodo_iac_variables_db_schema,
  )

  variables_secret = merge(
    local.nodo_iac_variables_secret_db_schema,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "nodo_iac_db_partitioned_data_migration" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.0.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.nodo_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.nodo_iac.pipeline.path
  pipeline_name                = var.nodo_iac.pipeline.db_partitioned_data_migration.name
  pipeline_yml_filename        = var.nodo_iac.pipeline.db_partitioned_data_migration.pipeline_yml_filename

  variables = merge(
    local.nodo_iac_variables,
    local.nodo_iac_variables_db_partitioned_data_migration,
  )

  variables_secret = merge(
    local.nodo_iac_variables_secret_db_partitioned_data_migration,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

# WEB-BO infra (PLAN+APPLY )& db migration
module "nodo_iac_web_bo_db_migration" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.0.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.nodo_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.nodo_iac.pipeline.path
  pipeline_name                = var.nodo_iac.pipeline.web_bo_db_migration.name
  pipeline_yml_filename        = var.nodo_iac.pipeline.web_bo_db_migration.pipeline_yml_filename

  variables = merge(
    local.nodo_iac_variables,
    local.nodo_iac_variables_web_bo_db_migration,
  )

  variables_secret = merge(
    local.nodo_iac_variables_secret_web_bo_db_migration,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "nodo_iac_web_bo_db_schema" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.0.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.nodo_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.nodo_iac.pipeline.path
  pipeline_name                = var.nodo_iac.pipeline.web_bo_db_schema.name
  pipeline_yml_filename        = var.nodo_iac.pipeline.web_bo_db_schema.pipeline_yml_filename

  variables = merge(
    local.nodo_iac_variables,
    local.nodo_iac_variables_web_bo_db_schema,
  )

  variables_secret = merge(
    local.nodo_iac_variables_secret_web_bo_db_schema,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "nodo_cron_alert_suspend_jobs" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v7.0.0"

  project_id                   = azuredevops_project.project.id
  repository                   = var.nodo_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.nodo_iac.pipeline.path
  pipeline_name                = var.nodo_iac.pipeline.nodo_cron_alert_suspend_jobs.name
  pipeline_yml_filename        = var.nodo_iac.pipeline.nodo_cron_alert_suspend_jobs.pipeline_yml_filename
  ci_trigger_enabled           = true
  ci_trigger_use_yaml          = true

  variables = merge(
    local.nodo_iac_variables,
    local.nodo_iac_variables_cron_alert_suspend_jobs,
  )

  variables_secret = merge(
    local.nodo_iac_variables_secret_cron_alert_suspend_jobs,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}
