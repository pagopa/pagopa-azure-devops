variable "pay_wallet_iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pay-wallet"
    }
    pipeline = {
      enable_code_review   = true
      enable_deploy        = true
      path                 = "pay-wallet-infrastructure"
      pipeline_name_prefix = "pay-wallet-infra"
    }
  }
}

locals {
  # global vars
  pay_wallet_iac_variables = {

    tf_aks_dev_name  = "pagopa-d-itn-dev-aks",
    tf_aks_uat_name  = "pagopa-u-itn-uat-aks",
    tf_aks_prod_name = "pagopa-p-itn-prod-aks",

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
  pay_wallet_iac_variables_secret = {
    tf_dev_aks_apiserver_url         = module.paywallet_dev_secrets.values["pagopa-d-itn-dev-aks-apiserver-url"].value,
    tf_dev_aks_azure_devops_sa_cacrt = module.paywallet_dev_secrets.values["pagopa-d-itn-dev-aks-azure-devops-sa-cacrt"].value,
    tf_dev_aks_azure_devops_sa_token = base64decode(module.paywallet_dev_secrets.values["pagopa-d-itn-dev-aks-azure-devops-sa-token"].value),


    tf_uat_aks_apiserver_url         = module.paywallet_uat_secrets.values["pagopa-u-itn-uat-aks-apiserver-url"].value,
    tf_uat_aks_azure_devops_sa_cacrt = module.paywallet_uat_secrets.values["pagopa-u-itn-uat-aks-azure-devops-sa-cacrt"].value,
    tf_uat_aks_azure_devops_sa_token = base64decode(module.paywallet_uat_secrets.values["pagopa-u-itn-uat-aks-azure-devops-sa-token"].value),

    tf_prod_aks_apiserver_url         = module.paywallet_prod_secrets.values["pagopa-p-itn-prod-aks-apiserver-url"].value,
    tf_prod_aks_azure_devops_sa_cacrt = module.paywallet_prod_secrets.values["pagopa-p-itn-prod-aks-azure-devops-sa-cacrt"].value,
    tf_prod_aks_azure_devops_sa_token = base64decode(module.paywallet_prod_secrets.values["pagopa-p-itn-prod-aks-azure-devops-sa-token"].value),

  }


  # code_review vars
  pay_wallet_iac_variables_code_review = {}
  # code_review secrets
  pay_wallet_iac_variables_secret_code_review = {}

  # deploy vars
  pay_wallet_iac_variables_deploy = {}
  # deploy secrets
  pay_wallet_iac_variables_secret_deploy = {}
}

module "pay_wallet_iac_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v7.0.0"
  count  = var.pay_wallet_iac.pipeline.enable_code_review == true ? 1 : 0
  path   = var.pay_wallet_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.pay_wallet_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.pay_wallet_iac.pipeline.pipeline_name_prefix



  variables = merge(
    local.pay_wallet_iac_variables,
    local.pay_wallet_iac_variables_code_review,
  )

  variables_secret = merge(
    local.pay_wallet_iac_variables_secret,
    local.pay_wallet_iac_variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

module "pay_wallet_iac_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v7.0.0"
  count  = var.pay_wallet_iac.pipeline.enable_deploy == true ? 1 : 0
  path   = var.pay_wallet_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.pay_wallet_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = var.pay_wallet_iac.pipeline.pipeline_name_prefix



  variables = merge(
    local.pay_wallet_iac_variables,
    local.pay_wallet_iac_variables_deploy,
  )

  variables_secret = merge(
    local.pay_wallet_iac_variables_secret,
    local.pay_wallet_iac_variables_secret_deploy,
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
