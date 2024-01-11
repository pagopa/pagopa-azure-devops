variable "pagopa-fdr-xml-to-json" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-fdr-xml-to-json"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = false
      enable_deploy      = true
      sonarcloud = {
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-fdr-xml-to-json"
        project_name       = "pagopa-fdr-xml-to-json"
      }
    }
  }
}

locals {
  pagopa-fdr-xml-to-json-variables = {
    default_branch = var.pagopa-fdr-xml-to-json.repository.branch_name
  }
  pagopa-fdr-xml-to-json-variables_secret = {

  }
  pagopa-fdr-xml-to-json-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-fdr-xml-to-json.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-fdr-xml-to-json.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-fdr-xml-to-json.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-fdr-xml-to-json.pipeline.sonarcloud.project_name
    # nodo4 variables of cd pipeline
  }
  pagopa-fdr-xml-to-json-variables_secret_code_review = {
  }

  pagopa-fdr-xml-to-json-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    dev_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name

    image_repository_name                = replace(var.pagopa-fdr-xml-to-json.repository.name, "-", "")
    dev_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    dev_web_app_name  = "pagopa-d-weu"
    uat_web_app_name  = "pagopa-u-weu"
    prod_web_app_name = "pagopa-p-weu"

    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

    #    TF_APPINSIGHTS_SERVICE_CONN_PROD = module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    #    TF_APPINSIGHTS_RESOURCE_ID_PROD  = data.azurerm_application_insights.application_insights_prod.id
  }

  # deploy secrets
  pagopa-fdr-xml-to-json-variables_secret_deploy = {

  }
}

module "pagopa-fdr-xml-to-json_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.5"
  count  = var.pagopa-fdr-xml-to-json.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-fdr-xml-to-json.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-fdr-xml-to-json"

  variables = merge(
    local.pagopa-fdr-xml-to-json-variables,
    local.pagopa-fdr-xml-to-json-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-fdr-xml-to-json-variables_secret,
    local.pagopa-fdr-xml-to-json-variables_secret_deploy,
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
    #    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id
  ]
}
