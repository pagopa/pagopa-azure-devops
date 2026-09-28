variable "pagopa-gpd-payments" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-gpd-payments"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      performance_test = {
        enabled               = true
        name                  = "performance-test-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-gpd-payments-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-gpd-payments.repository.branch_name
  }
  # global secrets
  pagopa-gpd-payments-variables_secret = {
    DEV_API_CONFIG_SUBSCRIPTION_KEY    = module.gps_dev_secrets.values["gpd-d-apiconfig-subscription-key"].value
    DEV_GPD_SUBSCRIPTION_KEY           = module.gps_dev_secrets.values["gpd-d-gpd-subscription-key"].value
    DEV_GPS_SUBSCRIPTION_KEY           = module.gps_dev_secrets.values["gpd-d-gps-subscription-key"].value
    DEV_DONATIONS_SUBSCRIPTION_KEY     = module.gps_dev_secrets.values["gpd-d-donations-subscription-key"].value
    DEV_IUV_GENERATOR_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-d-iuv-generator-subscription-key"].value
    DEV_PAYMENTS_REST_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-d-payments-rest-subscription-key"].value
    DEV_PAYMENTS_SOAP_SUBSCRIPTION_KEY = module.gps_dev_secrets.values["gpd-d-payments-soap-subscription-key"].value
    #####
    UAT_API_CONFIG_SUBSCRIPTION_KEY    = module.gps_uat_secrets.values["gpd-u-apiconfig-subscription-key"].value
    UAT_GPD_SUBSCRIPTION_KEY           = module.gps_uat_secrets.values["gpd-u-gpd-subscription-key"].value
    UAT_GPS_SUBSCRIPTION_KEY           = module.gps_uat_secrets.values["gpd-u-gps-subscription-key"].value
    UAT_DONATIONS_SUBSCRIPTION_KEY     = module.gps_uat_secrets.values["gpd-u-donations-subscription-key"].value
    UAT_IUV_GENERATOR_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-u-iuv-generator-subscription-key"].value
    UAT_PAYMENTS_REST_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-u-payments-rest-subscription-key"].value
    UAT_PAYMENTS_SOAP_SUBSCRIPTION_KEY = module.gps_uat_secrets.values["gpd-u-payments-soap-subscription-key"].value
  }

  ## Performance Test Pipeline vars and secrets ##

  # performance vars
  pagopa-gpd-payments-variables_performance_test = {
  }
  # performance secrets
  pagopa-gpd-payments-variables_secret_performance_test = {
  }
}

module "pagopa-gpd-payments_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-gpd-payments.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-gpd-payments.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-gpd-payments-service"
  pipeline_name                = var.pagopa-gpd-payments.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-gpd-payments.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-gpd-payments-variables,
    local.pagopa-gpd-payments-variables_performance_test
  )

  variables_secret = merge(
    local.pagopa-gpd-payments-variables_secret,
    local.pagopa-gpd-payments-variables_secret_performance_test
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
