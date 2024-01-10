variable "pagopa-pdf-engine" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-pdf-engine"
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
  pagopa-pdf-engine-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-pdf-engine.repository.branch_name
  }
  # global secrets
  pagopa-pdf-engine-variables_secret = {

  }

  ## Deploy Pipeline vars and secrets ##

  # deploy vars
  pagopa-pdf-engine-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = module.secrets.values["TENANTID"].value

    dev_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name

    # acr section
    image_repository_name                = replace(var.pagopa-pdf-engine.repository.name, "-", "")
    dev_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"


    dev_web_app_name                 = "pagopa-d-weu-shared-app-pdf-engine"
    dev_web_app_resource_group_name  = "pagopa-d-weu-shared-pdf-engine-rg"
    uat_web_app_name                 = "pagopa-u-weu-shared-app-pdf-engine"
    uat_web_app_resource_group_name  = "pagopa-u-weu-shared-pdf-engine-rg"
    prod_web_app_name                = "pagopa-p-weu-shared-app-pdf-engine"
    prod_web_app_resource_group_name = "pagopa-p-weu-shared-pdf-engine-rg"


    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

    TF_APPINSIGHTS_SERVICE_CONN_PROD = module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_PROD  = data.azurerm_application_insights.application_insights_prod.id
  }

  # deploy secrets
  pagopa-pdf-engine-variables_secret_deploy = {
    # secrets - dev environment
    # secrets - uat environment
  }

  # performance vars
  pagopa-pdf-engine-variables_performance_test = {
  }
  # performance secrets
  pagopa-pdf-engine-variables_secret_performance_test = {
    DEV_SUBSCRIPTION_KEY      = module.shared_dev_secrets.values["pdf-engine-d-perftest-subkey"].value
    UAT_JAVA_SUBSCRIPTION_KEY = module.shared_uat_secrets.values["pdf-engine-u-perftest-subkey"].value
    UAT_NODE_SUBSCRIPTION_KEY = module.shared_uat_secrets.values["pdf-engine-node-u-perftest-subkey"].value
  }

}


module "pagopa-pdf-engine-service_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.5"
  count  = var.pagopa-pdf-engine.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-pdf-engine.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-pdf-engine"

  variables = merge(
    local.pagopa-pdf-engine-variables,
    local.pagopa-pdf-engine-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-pdf-engine-variables_secret,
    local.pagopa-pdf-engine-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
    module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}


module "pagopa-pdf-engine_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.1.5"
  count  = var.pagopa-pdf-engine.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-pdf-engine.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  path                         = "${local.domain}\\pagopa-pdf-engine"
  pipeline_name                = var.pagopa-pdf-engine.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-pdf-engine.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-pdf-engine-variables,
    local.pagopa-pdf-engine-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-pdf-engine-variables_secret,
    local.pagopa-pdf-engine-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
  ]

}
