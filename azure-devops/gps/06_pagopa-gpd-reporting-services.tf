variable "pagopa-gpd-reporting-services" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-debt-position"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      # TODO to be replaced by the configuration under commented
      integration_test = {
        enabled               = true
        name                  = "gpd-reporting-services.integration-test"
        pipeline_yml_filename = "integration-test-pipelines.yml"
      }
      # enable_code_review = true
      # enable_deploy      = true
      # sonarcloud = {
      #   service_connection = "SONARCLOUD-SERVICE-CONN"
      #   org                = "pagopa"
      #   project_key        = "pagopa_pagopa-gpd-reporting-XXX"
      #   project_name       = "pagopa-gpd-reporting-XXX"
      # }
    }
  }
}

locals {
  # global vars
  pagopa-gpd-reporting-services-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-gpd-reporting-services.repository.branch_name
  }
  # global secrets
  pagopa-gpd-reporting-services-variables_secret = {
    # integration test secrets - dev environment
    DEV_API_CONFIG_SUBSCRIPTION_KEY       = module.gps_dev_secrets.values["gpd-d-apiconfig-subscription-key"].value
    DEV_GPD_SUBSCRIPTION_KEY              = module.gps_dev_secrets.values["gpd-d-gpd-subscription-key"].value
    DEV_PAYMENTS_REST_SUBSCRIPTION_KEY    = module.gps_dev_secrets.values["gpd-d-payments-rest-subscription-key"].value
    DEV_PAYMENTS_SOAP_SUBSCRIPTION_KEY    = module.gps_dev_secrets.values["gpd-d-payments-soap-subscription-key"].value
    DEV_REPORTING_SUBSCRIPTION_KEY        = module.gps_dev_secrets.values["gpd-d-reporting-subscription-key"].value
    DEV_REPORTING_BATCH_CONNECTION_STRING = module.gps_dev_secrets.values["gpd-d-reporting-batch-connection-string"].value

    # integration test secrets - uat environment
    UAT_API_CONFIG_SUBSCRIPTION_KEY       = module.gps_uat_secrets.values["gpd-u-apiconfig-subscription-key"].value
    UAT_GPD_SUBSCRIPTION_KEY              = module.gps_uat_secrets.values["gpd-u-gpd-subscription-key"].value
    UAT_PAYMENTS_REST_SUBSCRIPTION_KEY    = module.gps_uat_secrets.values["gpd-u-payments-rest-subscription-key"].value
    UAT_PAYMENTS_SOAP_SUBSCRIPTION_KEY    = module.gps_uat_secrets.values["gpd-u-payments-soap-subscription-key"].value
    UAT_REPORTING_SUBSCRIPTION_KEY        = module.gps_uat_secrets.values["gpd-u-reporting-subscription-key"].value
    UAT_REPORTING_BATCH_CONNECTION_STRING = module.gps_uat_secrets.values["gpd-u-reporting-batch-connection-string"].value
  }
}

module "pagopa-gpd-reporting-services_integration-test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v2.6.3"
  count  = var.pagopa-gpd-reporting-services.pipeline.integration_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-reporting-services.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  path                         = "${local.domain}\\pagopa-gpd-reporting-services"
  pipeline_name                = var.pagopa-gpd-reporting-services.pipeline.integration_test.name
  pipeline_yml_filename        = var.pagopa-gpd-reporting-services.pipeline.integration_test.pipeline_yml_filename


  variables = merge(
    local.pagopa-gpd-reporting-services-variables
  )

  variables_secret = merge(
    local.pagopa-gpd-reporting-services-variables_secret
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]
}
