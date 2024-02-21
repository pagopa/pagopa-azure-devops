variable "ecommerce_iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "ecommerce"
    }
    pipeline = {
      enable_code_review   = true
      enable_deploy        = true
      path                 = "ecommerce-infrastructure"
      pipeline_name_prefix = "ecommerce-infra"
    }
  }
}

locals {
  # global vars
  ecommerce_iac_variables = {
    tf_dev_aks_apiserver_url         = module.ecommerce_dev_secrets.values["pagopa-d-weu-dev-aks-apiserver-url"].value,
    tf_dev_aks_azure_devops_sa_cacrt = module.ecommerce_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-cacrt"].value,
    tf_dev_aks_azure_devops_sa_token = base64decode(module.ecommerce_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-token"].value),
    tf_aks_dev_name                  = var.aks_dev_platform_name
    tf_dev_azure_service_connection  = azuredevops_serviceendpoint_azurerm.DEV-PAGOPA-IAC-LEGACY.service_endpoint_name

    tf_uat_aks_apiserver_url         = module.ecommerce_uat_secrets.values["pagopa-u-weu-uat-aks-apiserver-url"].value,
    tf_uat_aks_azure_devops_sa_cacrt = module.ecommerce_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-cacrt"].value,
    tf_uat_aks_azure_devops_sa_token = base64decode(module.ecommerce_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-token"].value),
    tf_aks_uat_name                  = var.aks_uat_platform_name
    tf_uat_azure_service_connection  = azuredevops_serviceendpoint_azurerm.UAT-PAGOPA-IAC-LEGACY.service_endpoint_name

    tf_prod_aks_apiserver_url         = module.ecommerce_prod_secrets.values["pagopa-p-weu-prod-aks-apiserver-url"].value,
    tf_prod_aks_azure_devops_sa_cacrt = module.ecommerce_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value,
    tf_prod_aks_azure_devops_sa_token = base64decode(module.ecommerce_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-token"].value),
    tf_aks_prod_name                  = var.aks_prod_platform_name

    TF_POOL_NAME_DEV  = "pagopa-dev-linux-infra",
    TF_POOL_NAME_UAT  = "pagopa-uat-linux-infra",
    TF_POOL_NAME_PROD = "pagopa-prod-linux-infra",
    #PLAN
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV  = module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_UAT  = module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_PROD = module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
    #APPLY
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV  = module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT  = module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
    TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD = module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,

  }
  # global secrets
  ecommerce_iac_variables_secret = {}

  # code_review vars
  ecommerce_iac_variables_code_review = {}
  # code_review secrets
  ecommerce_iac_variables_secret_code_review = {}

  # deploy vars
  ecommerce_iac_variables_deploy = {}
  # deploy secrets
  ecommerce_iac_variables_secret_deploy = {
    AZURE_DEVOPS_GITHUB_PR_TOKEN = module.secrets.values["azure-devops-github-pr-TOKEN"].value
  }
}

module "ecommerce_iac_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v7.0.0"
  count  = var.ecommerce_iac.pipeline.enable_code_review == true ? 1 : 0
  path   = var.ecommerce_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.ecommerce_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.ecommerce_iac.pipeline.pipeline_name_prefix



  variables = merge(
    local.ecommerce_iac_variables,
    local.ecommerce_iac_variables_code_review,
  )

  variables_secret = merge(
    local.ecommerce_iac_variables_secret,
    local.ecommerce_iac_variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "ecommerce_iac_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v7.0.0"
  count  = var.ecommerce_iac.pipeline.enable_deploy == true ? 1 : 0
  path   = var.ecommerce_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.ecommerce_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.ecommerce_iac.pipeline.pipeline_name_prefix



  variables = merge(
    local.ecommerce_iac_variables,
    local.ecommerce_iac_variables_deploy,
  )

  variables_secret = merge(
    local.ecommerce_iac_variables_secret,
    local.ecommerce_iac_variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,

    module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
  ]
}
