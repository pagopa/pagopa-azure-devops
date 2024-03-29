variable "pagopa-receipt-pdf-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-receipt-pdf-service"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_deploy = true
      performance_test = {
        enabled               = true
        name                  = "performance-test-receipt-pdf-service-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-receipt-pdf-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-receipt-pdf-service.repository.branch_name
  }
  # global secrets
  pagopa-receipt-pdf-service-variables_secret = {

  }

  # performance vars
  pagopa-receipt-pdf-service-variables_performance_test = {
  }
  # performance secrets
  pagopa-receipt-pdf-service-variables_secret_performance_test = {

    DEV_API_SUBSCRIPTION_KEY                = module.receipts_dev_secrets.values["apikey-service-receipt"].value
    DEV_BLOB_STORAGE_CONNECTION_STRING      = module.receipts_dev_secrets.values["receipts-storage-account-connection-string"].value
    DEV_RECEIPT_COSMOS_DB_CONNECTION_STRING = module.receipts_dev_secrets.values["cosmos-receipt-connection-string"].value

    UAT_API_SUBSCRIPTION_KEY                = module.receipts_uat_secrets.values["apikey-service-receipt"].value
    UAT_BLOB_STORAGE_CONNECTION_STRING      = module.receipts_uat_secrets.values["receipts-storage-account-connection-string"].value
    UAT_RECEIPT_COSMOS_DB_CONNECTION_STRING = module.receipts_uat_secrets.values["cosmos-receipt-connection-string"].value
  }
}


module "pagopa-receipt-pdf-service_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-receipt-pdf-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-receipt-pdf-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-receipt-pdf-service"
  pipeline_name                = var.pagopa-receipt-pdf-service.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-receipt-pdf-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-receipt-pdf-service-variables,
    local.pagopa-receipt-pdf-service-variables_performance_test
  )

  variables_secret = merge(
    local.pagopa-receipt-pdf-service-variables_secret,
    local.pagopa-receipt-pdf-service-variables_secret_performance_test
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
