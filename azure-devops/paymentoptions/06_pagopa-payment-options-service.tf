variable "pagopa-payment-options-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-payment-options-service"
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
  pagopa-payment-options-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-payment-options-service.repository.branch_name
  }
  # global secrets
  pagopa-payment-options-service-variables_secret = {

  }

  # performance vars
  pagopa-payment-options-service-variables_performance_test = {
  }
  # performance secrets
  pagopa-payment-options-service-variables_secret_performance_test = {
    # DEV_API_SUBSCRIPTION_KEY                = module.general_dev_secrets.values["integration-test-subkey"].value
    # DEV_BLOB_INSTITUTIONS_CONNECTION_STRING = module.payopt_dev_secrets.values["institutions-storage-account-connection-string"].value
    # DEV_BLOB_NOTICES_CONNECTION_STRING      = module.payopt_dev_secrets.values["notices-storage-account-connection-string"].value
    # DEV_MONGO_NOTICES_CONNECTION_STRING     = module.payopt_dev_secrets.values["notices-mongo-connection-string"].value

    # UAT_API_SUBSCRIPTION_KEY                = module.general_uat_secrets.values["integration-test-subkey"].value
    # UAT_BLOB_INSTITUTIONS_CONNECTION_STRING = module.payopt_uat_secrets.values["institutions-storage-account-connection-string"].value
    # UAT_BLOB_NOTICES_CONNECTION_STRING      = module.payopt_uat_secrets.values["notices-storage-account-connection-string"].value
    # UAT_MONGO_NOTICES_CONNECTION_STRING     = module.payopt_uat_secrets.values["notices-mongo-connection-string"].value

    # PROD_API_SUBSCRIPTION_KEY                = module.general_prod_secrets.values["integration-test-subkey"].value
    # PROD_BLOB_INSTITUTIONS_CONNECTION_STRING = module.payopt_prod_secrets.values["institutions-storage-account-connection-string"].value
    # PROD_BLOB_NOTICES_CONNECTION_STRING      = module.payopt_prod_secrets.values["notices-storage-account-connection-string"].value
    # PROD_MONGO_NOTICES_CONNECTION_STRING     = module.payopt_prod_secrets.values["notices-mongo-connection-string"].value
  }

}


module "pagopa-payment-options-service_performance_test" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_generic"
  count  = var.pagopa-payment-options-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-payment-options-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-payment-options-service"
  pipeline_name                = var.pagopa-payment-options-service.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-payment-options-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-payment-options-service-variables,
    local.pagopa-payment-options-service-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-payment-options-service-variables_secret,
    local.pagopa-payment-options-service-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
