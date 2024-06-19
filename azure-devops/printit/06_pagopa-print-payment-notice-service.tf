variable "pagopa-print-payment-notice-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-print-payment-notice-service"
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
  pagopa-print-payment-notice-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-print-payment-notice-service.repository.branch_name
  }
  # global secrets
  pagopa-print-payment-notice-service-variables_secret = {

  }

  # performance vars
  pagopa-print-payment-notice-service-variables_performance_test = {
  }
  # performance secrets
  pagopa-print-payment-notice-service-variables_secret_performance_test = {
    DEV_API_SUBSCRIPTION_KEY                = module.general_dev_secrets.values["integration-test-subkey"].value
    DEV_BLOB_INSTITUTIONS_CONNECTION_STRING = module.printit_dev_secrets.values["institutions-storage-account-connection-string"].value
    DEV_BLOB_NOTICES_CONNECTION_STRING      = module.printit_dev_secrets.values["notices-storage-account-connection-string"].value
    DEV_MONGO_NOTICES_CONNECTION_STRING     = module.printit_uat_secrets.values["notices-mongo-connection-string"].value

    UAT_API_SUBSCRIPTION_KEY                = module.general_uat_secrets.values["integration-test-subkey"].value
    UAT_BLOB_INSTITUTIONS_CONNECTION_STRING = module.printit_uat_secrets.values["institutions-storage-account-connection-string"].value
    UAT_BLOB_NOTICES_CONNECTION_STRING      = module.printit_uat_secrets.values["notices-storage-account-connection-string"].value
    UAT_MONGO_NOTICES_CONNECTION_STRING     = module.printit_uat_secrets.values["notices-mongo-connection-string"].value
  }

}


module "pagopa-print-payment-notice-service_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-print-payment-notice-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-print-payment-notice-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-print-payment-notice-service"
  pipeline_name                = var.pagopa-print-payment-notice-service.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-print-payment-notice-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-print-payment-notice-service-variables,
    local.pagopa-print-payment-notice-service-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-print-payment-notice-service-variables_secret,
    local.pagopa-print-payment-notice-service-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
