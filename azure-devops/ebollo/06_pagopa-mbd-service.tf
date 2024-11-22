variable "pagopa-mbd-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-mbd-service"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      performance_test = {
        enabled               = true
        name                  = "performance-test-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yaml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-mbd-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-mbd-service.repository.branch_name
  }
  # global secrets
  pagopa-mbd-service-variables_secret = {

  }

  # performance vars
  pagopa-mbd-service-variables_performance_test = {
  }
  # performance secrets
  pagopa-mbd-service-variables_secret_performance_test = {
    # DEV_API_SUBSCRIPTION_KEY                = module.general_dev_secrets.values["integration-test-subkey"].value
    # DEV_BLOB_INSTITUTIONS_CONNECTION_STRING = module.ebollo_dev_secrets.values["institutions-storage-account-connection-string"].value
    # DEV_BLOB_NOTICES_CONNECTION_STRING      = module.ebollo_dev_secrets.values["notices-storage-account-connection-string"].value
    # DEV_MONGO_NOTICES_CONNECTION_STRING     = module.ebollo_dev_secrets.values["notices-mongo-connection-string"].value

    # UAT_API_SUBSCRIPTION_KEY                = module.general_uat_secrets.values["integration-test-subkey"].value
    # UAT_BLOB_INSTITUTIONS_CONNECTION_STRING = module.ebollo_uat_secrets.values["institutions-storage-account-connection-string"].value
    # UAT_BLOB_NOTICES_CONNECTION_STRING      = module.ebollo_uat_secrets.values["notices-storage-account-connection-string"].value
    # UAT_MONGO_NOTICES_CONNECTION_STRING     = module.ebollo_uat_secrets.values["notices-mongo-connection-string"].value

    # PROD_API_SUBSCRIPTION_KEY                = module.general_prod_secrets.values["integration-test-subkey"].value
    # PROD_BLOB_INSTITUTIONS_CONNECTION_STRING = module.ebollo_prod_secrets.values["institutions-storage-account-connection-string"].value
    # PROD_BLOB_NOTICES_CONNECTION_STRING      = module.ebollo_prod_secrets.values["notices-storage-account-connection-string"].value
    # PROD_MONGO_NOTICES_CONNECTION_STRING     = module.ebollo_prod_secrets.values["notices-mongo-connection-string"].value
  }

}


module "pagopa-mbd-service_performance_test" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_generic"
  count  = var.pagopa-mbd-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-mbd-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-mbd-service"
  pipeline_name                = var.pagopa-mbd-service.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-mbd-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-mbd-service-variables,
    local.pagopa-mbd-service-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-mbd-service-variables_secret,
    local.pagopa-mbd-service-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
