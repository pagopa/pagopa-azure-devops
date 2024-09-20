locals {
  default_repository = {
    organization   = "pagopa"
    name           = "pagopa-infra"
    branch_name    = "refs/heads/main"
    pipelines_path = ".devops"
  }

  code_review_domains = [for d in local.definitions : d if d.code_review == true]
  deploy_domains      = [for d in local.definitions : d if d.deploy == true]


  base_iac_variables = {
    tf_aks_dev_name  = local.aks_dev_platform_name
    tf_aks_uat_name  = local.aks_uat_platform_name
    tf_aks_prod_name = local.aks_prod_platform_name

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

  # code review vars
  base_iac_variables_code_review = {}
  # code review secrets
  base_iac_variables_secret = {}
  # deploy vars
  base_iac_variables_deploy = {}
  # deploy secrets
  base_aca_iac_variables_secret_deploy = {}
}


##################################################
# HOW TO DEFINE A PIPELINE FOR A NEW DOMAIN?     #
# have a look at README.md                       #
##################################################
module "iac_code_review" {
  source   = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v7.0.0"
  for_each = { for d in local.code_review_domains : d.name => d }
  path     = each.value.pipeline_path

  project_id                   = data.azuredevops_project.project.id
  repository                   = merge(local.default_repository, each.value.repository)
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = each.value.pipeline_prefix

  variables = merge(
    local.base_iac_variables,
    contains(each.value.envs, "d") && try(each.value.kv_name, "") != "" ? {
      tf_dev_aks_apiserver_url         = module.dev_secrets[each.value.name].values["pagopa-d-weu-dev-aks-apiserver-url"].value,
      tf_dev_aks_azure_devops_sa_cacrt = module.dev_secrets[each.value.name].values["pagopa-d-weu-dev-aks-azure-devops-sa-cacrt"].value,
      tf_dev_aks_azure_devops_sa_token = base64decode(module.dev_secrets[each.value.name].values["pagopa-d-weu-dev-aks-azure-devops-sa-token"].value),
    } : {},
    contains(each.value.envs, "u") && try(each.value.kv_name, "") != "" ? {
      tf_uat_aks_apiserver_url         = module.uat_secrets[each.value.name].values["pagopa-u-weu-uat-aks-apiserver-url"].value,
      tf_uat_aks_azure_devops_sa_cacrt = module.uat_secrets[each.value.name].values["pagopa-u-weu-uat-aks-azure-devops-sa-cacrt"].value,
      tf_uat_aks_azure_devops_sa_token = base64decode(module.uat_secrets[each.value.name].values["pagopa-u-weu-uat-aks-azure-devops-sa-token"].value),
    } : {},
    contains(each.value.envs, "p") && try(each.value.kv_name, "") != "" ? {
      tf_prod_aks_apiserver_url         = module.prod_secrets[each.value.name].values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value,
      tf_prod_aks_azure_devops_sa_cacrt = module.prod_secrets[each.value.name].values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value,
      tf_prod_aks_azure_devops_sa_token = base64decode(module.prod_secrets[each.value.name].values["pagopa-p-weu-prod-aks-azure-devops-sa-token"].value),
    } : {},
    local.base_iac_variables_code_review,
    try(local.domain_variables[each.value.name].iac_variables_cr, {})
  )

  variables_secret = merge(
    local.base_iac_variables_secret,
    try(local.domain_variables[each.value.name].iac_variables_secrets_cr, {})
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
  ]
}

##################################################
# HOW TO DEFINE A PIPELINE FOR A NEW DOMAIN?     #
# have a look at README.md                       #
##################################################
module "iac_deploy" {
  source   = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v7.0.0"
  for_each = { for d in local.deploy_domains : d.name => d }
  path     = each.value.pipeline_path

  project_id                   = data.azuredevops_project.project.id
  repository                   = merge(local.default_repository, each.value.repository)
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = each.value.pipeline_prefix

  variables = merge(
    local.base_iac_variables,
    contains(each.value.envs, "d") && try(each.value.kv_name, "") != "" ? {
      tf_dev_aks_apiserver_url         = module.dev_secrets[each.value.name].values["pagopa-d-weu-dev-aks-apiserver-url"].value,
      tf_dev_aks_azure_devops_sa_cacrt = module.dev_secrets[each.value.name].values["pagopa-d-weu-dev-aks-azure-devops-sa-cacrt"].value,
      tf_dev_aks_azure_devops_sa_token = base64decode(module.dev_secrets[each.value.name].values["pagopa-d-weu-dev-aks-azure-devops-sa-token"].value),
    } : {},
    contains(each.value.envs, "u") && try(each.value.kv_name, "") != "" ? {
      tf_uat_aks_apiserver_url         = module.uat_secrets[each.value.name].values["pagopa-u-weu-uat-aks-apiserver-url"].value,
      tf_uat_aks_azure_devops_sa_cacrt = module.uat_secrets[each.value.name].values["pagopa-u-weu-uat-aks-azure-devops-sa-cacrt"].value,
      tf_uat_aks_azure_devops_sa_token = base64decode(module.uat_secrets[each.value.name].values["pagopa-u-weu-uat-aks-azure-devops-sa-token"].value),
    } : {},
    contains(each.value.envs, "p") && try(each.value.kv_name, "") != "" ? {
      tf_prod_aks_apiserver_url         = module.prod_secrets[each.value.name].values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value,
      tf_prod_aks_azure_devops_sa_cacrt = module.prod_secrets[each.value.name].values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value,
      tf_prod_aks_azure_devops_sa_token = base64decode(module.prod_secrets[each.value.name].values["pagopa-p-weu-prod-aks-azure-devops-sa-token"].value),
    } : {},
    local.base_iac_variables_deploy,
    try(local.domain_variables[each.value.name].iac_variables_deploy, {})
  )

  variables_secret = merge(
    local.base_iac_variables_secret,
    try(local.domain_variables[each.value.name].iac_variables_secrets_deploy, {})
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
