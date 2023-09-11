variable "pagopa-receipt-pdf-generator" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-receipt-pdf-generator"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_deploy = true
      performance_test = {
        enabled               = true
        name                  = "performance-test-receipt-pdf-generator-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-receipt-pdf-generator-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-receipt-pdf-generator.repository.branch_name
  }
  # global secrets
  pagopa-receipt-pdf-generator-variables_secret = {

  }

  # performance vars
  pagopa-receipt-pdf-generator-variables_performance_test = {
  }
  # performance secrets
  pagopa-receipt-pdf-generator-variables_secret_performance_test = {
    DEV_RECEIPT_QUEUE_SUBSCRIPTION_KEY = module.receipts_dev_secrets.values["receipts-storage-account-pkey"].value
    DEV_RECEIPT_COSMOS_DB_SUBSCRIPTION_KEY  = module.receipts_dev_secrets.values["cosmos-receipt-pkey"].value

    UAT_RECEIPT_QUEUE_SUBSCRIPTION_KEY = module.receipts_uat_secrets.values["receipts-storage-account-pkey"].value
    UAT_RECEIPT_COSMOS_DB_SUBSCRIPTION_KEY  = module.receipts_uat_secrets.values["cosmos-receipt-pkey"].value
  }
}


module "pagopa-receipt-pdf-generator_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v2.6.3"
  count  = var.pagopa-receipt-pdf-generator.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-receipt-pdf-generator.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-receipt-pdf-generator"
  pipeline_name                = var.pagopa-receipt-pdf-generator.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-receipt-pdf-generator.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-receipt-pdf-generator-variables,
    local.pagopa-receipt-pdf-generator-variables_performance_test
  )

  variables_secret = merge(
    local.pagopa-receipt-pdf-generator-variables_secret,
    local.pagopa-receipt-pdf-generator-variables_secret_performance_test
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}
