variable "pagopa-selfcare-ms-notification-manager" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "selfcare-ms-notification-manager"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pagopa"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      sonarcloud = {
        # TODO azure devops terraform provider does not support SonarCloud service endpoint
        service_connection = "SONARCLOUD-SERVICE-CONN"
        org                = "pagopa"
        project_key        = "pagopa_pagopa-selfcare-ms-notification-manager"
        project_name       = "pagopa-selfcare-ms-notification-manager"
      }
    }
  }
}

locals {
  # global vars
  pagopa-selfcare-ms-notification-manager-variables = {
    cache_version_id                 = "v1"
    default_branch                   = var.pagopa-selfcare-ms-notification-manager.repository.branch_name
    settings_xml_ro_secure_file_name = "settings-ro.xml"
  }

  # global secrets
  pagopa-selfcare-ms-notification-manager-variables_secret = {

  }

  # code_review vars
  pagopa-selfcare-ms-notification-manager-variables_code_review = {
    danger_github_api_token = "skip"
    sonarcloud_service_conn = var.pagopa-selfcare-ms-notification-manager.pipeline.sonarcloud.service_connection
    sonarcloud_org          = var.pagopa-selfcare-ms-notification-manager.pipeline.sonarcloud.org
    sonarcloud_project_key  = var.pagopa-selfcare-ms-notification-manager.pipeline.sonarcloud.project_key
    sonarcloud_project_name = var.pagopa-selfcare-ms-notification-manager.pipeline.sonarcloud.project_name
  }

  # code_review secrets
  pagopa-selfcare-ms-notification-manager-variables_secret_code_review = {
  }

  # deploy vars
  pagopa-selfcare-ms-notification-manager-variables_deploy = {
    git_mail          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username      = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_name
    tenant_id         = data.azurerm_client_config.current.tenant_id

    # acr section
    image_repository_name                = replace(var.pagopa-selfcare-ms-notification-manager.repository.name, "-", "")
    dev_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_dev_id
    uat_container_registry_service_conn  = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_uat_id
    prod_container_registry_service_conn = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_acr_aks_prod_id

    # custom section
    dev_azure_client_secret            = module.selfcare_dev_secrets.values["pagopa-selfcare-d-azure-client-secret"].value
    dev_azure_client_id                = module.selfcare_dev_secrets.values["pagopa-selfcare-d-azure-client-id"].value
    dev_selfcare-apim-external-api-key = module.selfcare_dev_secrets.values["selfcare-d-apim-external-api-key"].value
    dev_subscription_id                = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id

    uat_azure_client_secret            = module.selfcare_uat_secrets.values["pagopa-selfcare-u-azure-client-secret"].value
    uat_azure_client_id                = module.selfcare_uat_secrets.values["pagopa-selfcare-u-azure-client-id"].value
    uat_selfcare-apim-external-api-key = module.selfcare_uat_secrets.values["selfcare-u-apim-external-api-key"].value
    uat_subscription_id                = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id

    prod_azure_client_secret            = module.selfcare_prod_secrets.values["pagopa-selfcare-p-azure-client-secret"].value
    prod_azure_client_id                = module.selfcare_prod_secrets.values["pagopa-selfcare-p-azure-client-id"].value
    prod_selfcare-apim-external-api-key = module.selfcare_prod_secrets.values["selfcare-p-apim-external-api-key"].value
    prod_subscription_id                = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id

    # aks section

    k8s_namespace                = "selfcare"
    dev_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn  = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

    dev_container_namespace  = "pagopadcommonacr.azurecr.io"
    uat_container_namespace  = "pagopaucommonacr.azurecr.io"
    prod_container_namespace = "pagopapcommonacr.azurecr.io"

    # apim
    dev_external_api_service_url = "https://api.dev.selfcare.pagopa.it"
    dev_azure_resource_group     = "pagopa-d-api-rg"
    dev_azure_service_name       = "pagopa-d-apim"

    uat_external_api_service_url = "https://api.uat.selfcare.pagopa.it"
    uat_azure_resource_group     = "pagopa-u-api-rg"
    uat_azure_service_name       = "pagopa-u-apim"

    prod_external_api_service_url = "https://api.selfcare.pagopa.it"
    prod_azure_resource_group     = "pagopa-p-api-rg"
    prod_azure_service_name       = "pagopa-p-apim"

    # APP Insight
    TF_APPINSIGHTS_SERVICE_CONN_DEV = module.DEV-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_DEV  = data.azurerm_application_insights.application_insights_dev.id

    TF_APPINSIGHTS_SERVICE_CONN_UAT = module.UAT-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_UAT  = data.azurerm_application_insights.application_insights_uat.id

    # APP Insight
    TF_APPINSIGHTS_SERVICE_CONN_PROD = module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_name
    TF_APPINSIGHTS_RESOURCE_ID_PROD  = data.azurerm_application_insights.application_insights_prod.id
  }

  # deploy secrets
  pagopa-selfcare-ms-notification-manager-variables_secret_deploy = {

  }
}

module "pagopa-selfcare-ms-notification-manager_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.5"
  count  = var.pagopa-selfcare-ms-notification-manager.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-selfcare-ms-notification-manager.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\pagopa-selfcare-ms-notification-manager"

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.pagopa-selfcare-ms-notification-manager-variables,
    local.pagopa-selfcare-ms-notification-manager-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-selfcare-ms-notification-manager-variables_secret,
    local.pagopa-selfcare-ms-notification-manager-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    local.azuredevops_serviceendpoint_sonarcloud_id,
  ]
}

module "pagopa-selfcare-ms-notification-manager_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.5"
  count  = var.pagopa-selfcare-ms-notification-manager.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-selfcare-ms-notification-manager.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\pagopa-selfcare-ms-notification-manager"

  variables = merge(
    local.pagopa-selfcare-ms-notification-manager-variables,
    local.pagopa-selfcare-ms-notification-manager-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-selfcare-ms-notification-manager-variables_secret,
    local.pagopa-selfcare-ms-notification-manager-variables_secret_deploy,
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
    module.PROD-APPINSIGHTS-SERVICE-CONN.service_endpoint_id,
  ]
}
