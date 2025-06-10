variable "pagopa-anonymizer" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-anonymizer"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_deploy = true
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
  pagopa-anonymizer-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-anonymizer.repository.branch_name
  }
  # global secrets
  pagopa-anonymizer-variables_secret = {

  }

  ## Deploy Pipeline vars and secrets ##

  # deploy vars
  pagopa-anonymizer-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    dev_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.dev.service_endpoint_name
    uat_azure_subscription  = data.azuredevops_serviceendpoint_azurerm.uat.service_endpoint_name
    prod_azure_subscription = data.azuredevops_serviceendpoint_azurerm.prod.service_endpoint_name

    # acr section
    image_repository_name                = replace(var.pagopa-anonymizer.repository.name, "-", "")
    dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.dev.id
    uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.uat.id
    prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.prod.id

    itn_dev_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.itn_dev.id
    itn_uat_container_registry_service_conn  = data.azuredevops_serviceendpoint_azurecr.itn_uat.id
    itn_prod_container_registry_service_conn = data.azuredevops_serviceendpoint_azurecr.itn_prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    itn_dev_container_namespace  = "pagopaditncoreacr.azurecr.io"
    itn_uat_container_namespace  = "pagopauitncoreacr.azurecr.io"
    itn_prod_container_namespace = "pagopapitncoreacr.azurecr.io"


    dev_web_app_name                 = "pagopa-d-weu-shared-app-anonymizer"
    dev_web_app_resource_group_name  = "pagopa-d-weu-shared-anonymizer-rg"
    uat_web_app_name                 = "pagopa-u-weu-shared-app-anonymizer"
    uat_web_app_resource_group_name  = "pagopa-u-weu-shared-anonymizer-rg"
    prod_web_app_name                = "pagopa-p-weu-shared-app-anonymizer"
    prod_web_app_resource_group_name = "pagopa-p-weu-shared-anonymizer-rg"


    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

    TF_APPINSIGHTS_SERVICE_CONN_PROD = module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_PROD  = data.azurerm_application_insights.application_insights_prod.id
  }

  # deploy secrets
  pagopa-anonymizer-variables_secret_deploy = {
    # secrets - dev environment
    # secrets - uat environment
  }

  # performance vars
  pagopa-anonymizer-variables_performance_test = {
  }
  # performance secrets
  pagopa-anonymizer-variables_secret_performance_test = {
    DEV_SUBSCRIPTION_KEY = module.shared_dev_secrets.values["shared-anonymizer-api-key"].value
    UAT_SUBSCRIPTION_KEY = module.shared_uat_secrets.values["shared-anonymizer-api-key"].value
  }

}


module "pagopa-anonymizer-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.2.1"
  count  = var.pagopa-anonymizer.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-anonymizer.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-anonymizer"

  variables = merge(
    local.pagopa-anonymizer-variables,
    local.pagopa-anonymizer-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-anonymizer-variables_secret,
    local.pagopa-anonymizer-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurecr.dev.id,
    data.azuredevops_serviceendpoint_azurecr.uat.id,
    data.azuredevops_serviceendpoint_azurecr.prod.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}


module "pagopa-anonymizer_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-anonymizer.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-anonymizer.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                         = "${local.domain}\\pagopa-anonymizer"
  pipeline_name                = var.pagopa-anonymizer.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-anonymizer.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-anonymizer-variables,
    local.pagopa-anonymizer-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-anonymizer-variables_secret,
    local.pagopa-anonymizer-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]

}
