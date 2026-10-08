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

  project_id                   = azuredevops_project.project.id
  repository                   = merge(local.default_repository, each.value.repository)
  github_service_connection_id = try(each.value.repository.name, "pagopa-infra") == "pagopa-infra-core" ? azuredevops_serviceendpoint_github.azure-devops-github-infra-core-pr.id : azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = each.value.pipeline_prefix

  variables = merge(
    local.base_iac_variables,
    contains(each.value.envs, "d") && try(each.value.key_vaults, {}) != {} ? {
      tf_dev_aks_apiserver_url         = module.dev_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-d-${each.value.regions[0]}-dev-aks-apiserver-url"].value,
      tf_dev_aks_azure_devops_sa_cacrt = module.dev_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-d-${each.value.regions[0]}-dev-aks-azure-devops-sa-cacrt"].value,
      tf_dev_aks_azure_devops_sa_token = base64decode(module.dev_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-d-${each.value.regions[0]}-dev-aks-azure-devops-sa-token"].value),
      tf_aks_dev_name                  = "pagopa-d-${each.value.regions[0]}-dev-aks"
    } : {},
    contains(each.value.envs, "d") && try(each.value.key_vaults, {}) != {} && length(each.value.regions) > 1 ? {
      tf_second_dev_aks_apiserver_url         = module.dev_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-d-${each.value.regions[1]}-dev-aks-apiserver-url"].value,
      tf_second_dev_aks_azure_devops_sa_cacrt = module.dev_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-d-${each.value.regions[1]}-dev-aks-azure-devops-sa-cacrt"].value,
      tf_second_dev_aks_azure_devops_sa_token = base64decode(module.dev_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-d-${each.value.regions[1]}-dev-aks-azure-devops-sa-token"].value),
      tf_second_aks_dev_name                  = "pagopa-d-${each.value.regions[1]}-dev-aks"
    } : {},
    contains(each.value.envs, "u") && try(each.value.key_vaults, {}) != {} ? {
      tf_uat_aks_apiserver_url         = module.uat_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-u-${each.value.regions[0]}-uat-aks-apiserver-url"].value,
      tf_uat_aks_azure_devops_sa_cacrt = module.uat_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-u-${each.value.regions[0]}-uat-aks-azure-devops-sa-cacrt"].value,
      tf_uat_aks_azure_devops_sa_token = base64decode(module.uat_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-u-${each.value.regions[0]}-uat-aks-azure-devops-sa-token"].value),
      tf_aks_uat_name                  = "pagopa-u-${each.value.regions[0]}-uat-aks"
    } : {},
    contains(each.value.envs, "u") && try(each.value.key_vaults, {}) != {} && length(each.value.regions) > 1 ? {
      tf_second_uat_aks_apiserver_url         = module.uat_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-u-${each.value.regions[1]}-uat-aks-apiserver-url"].value,
      tf_second_uat_aks_azure_devops_sa_cacrt = module.uat_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-u-${each.value.regions[1]}-uat-aks-azure-devops-sa-cacrt"].value,
      tf_second_uat_aks_azure_devops_sa_token = base64decode(module.uat_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-u-${each.value.regions[1]}-uat-aks-azure-devops-sa-token"].value),
      tf_second_aks_uat_name                  = "pagopa-u-${each.value.regions[1]}-uat-aks"
    } : {},
    contains(each.value.envs, "p") && try(each.value.key_vaults, {}) != {} ? {
      tf_prod_aks_apiserver_url         = module.prod_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-p-${each.value.regions[0]}-prod-aks-apiserver-url"].value,
      tf_prod_aks_azure_devops_sa_cacrt = module.prod_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-p-${each.value.regions[0]}-prod-aks-azure-devops-sa-cacrt"].value,
      tf_prod_aks_azure_devops_sa_token = base64decode(module.prod_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-p-${each.value.regions[0]}-prod-aks-azure-devops-sa-token"].value),
      tf_aks_prod_name                  = "pagopa-p-${each.value.regions[0]}-prod-aks"
    } : {},
    contains(each.value.envs, "p") && try(each.value.key_vaults, {}) != {} && length(each.value.regions) > 1 ? {
      tf_second_prod_aks_apiserver_url         = module.prod_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-p-${each.value.regions[1]}-prod-aks-apiserver-url"].value,
      tf_second_prod_aks_azure_devops_sa_cacrt = module.prod_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-p-${each.value.regions[1]}-prod-aks-azure-devops-sa-cacrt"].value,
      tf_second_prod_aks_azure_devops_sa_token = base64decode(module.prod_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-p-${each.value.regions[1]}-prod-aks-azure-devops-sa-token"].value),
      tf_second_aks_prod_name                  = "pagopa-p-${each.value.regions[1]}-prod-aks"
    } : {},
    local.base_iac_variables_code_review,
    try(local.definitions_variables[each.value.name].iac_variables_cr, {})
  )

  variables_secret = merge(
    local.base_iac_variables_secret,
    try(local.definitions_variables[each.value.name].iac_variables_secrets_cr, {})
  )

  service_connection_ids_authorization = [
    try(each.value.repository.name, "pagopa-infra") == "pagopa-infra-core" ? azuredevops_serviceendpoint_github.azure-devops-github-infra-core-ro.id : azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
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
  source   = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v7.0.0"
  for_each = { for d in local.deploy_domains : d.name => d }
  path     = each.value.pipeline_path

  project_id                   = azuredevops_project.project.id
  repository                   = merge(local.default_repository, each.value.repository)
  github_service_connection_id = try(each.value.repository.name, "pagopa-infra") == "pagopa-infra-core" ? azuredevops_serviceendpoint_github.azure-devops-github-infra-core-pr.id : azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  pipeline_name_prefix = each.value.pipeline_prefix

  variables = merge(
    local.base_iac_variables,
    contains(each.value.envs, "d") && try(each.value.key_vaults, {}) != {} ? {
      tf_dev_aks_apiserver_url         = module.dev_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-d-${each.value.regions[0]}-dev-aks-apiserver-url"].value,
      tf_dev_aks_azure_devops_sa_cacrt = module.dev_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-d-${each.value.regions[0]}-dev-aks-azure-devops-sa-cacrt"].value,
      tf_dev_aks_azure_devops_sa_token = base64decode(module.dev_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-d-${each.value.regions[0]}-dev-aks-azure-devops-sa-token"].value),
      tf_aks_dev_name                  = "pagopa-d-${each.value.regions[0]}-dev-aks"
    } : {},
    contains(each.value.envs, "d") && try(each.value.key_vaults, {}) != {} && length(each.value.regions) > 1 ? {
      tf_second_dev_aks_apiserver_url         = module.dev_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-d-${each.value.regions[1]}-dev-aks-apiserver-url"].value,
      tf_second_dev_aks_azure_devops_sa_cacrt = module.dev_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-d-${each.value.regions[1]}-dev-aks-azure-devops-sa-cacrt"].value,
      tf_second_dev_aks_azure_devops_sa_token = base64decode(module.dev_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-d-${each.value.regions[1]}-dev-aks-azure-devops-sa-token"].value),
      tf_second_aks_dev_name                  = "pagopa-d-${each.value.regions[1]}-dev-aks"
    } : {},
    contains(each.value.envs, "u") && try(each.value.key_vaults, {}) != {} ? {
      tf_uat_aks_apiserver_url         = module.uat_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-u-${each.value.regions[0]}-uat-aks-apiserver-url"].value,
      tf_uat_aks_azure_devops_sa_cacrt = module.uat_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-u-${each.value.regions[0]}-uat-aks-azure-devops-sa-cacrt"].value,
      tf_uat_aks_azure_devops_sa_token = base64decode(module.uat_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-u-${each.value.regions[0]}-uat-aks-azure-devops-sa-token"].value),
      tf_aks_uat_name                  = "pagopa-u-${each.value.regions[0]}-uat-aks"

    } : {},
    contains(each.value.envs, "u") && try(each.value.key_vaults, {}) != {} && length(each.value.regions) > 1 ? {
      tf_second_uat_aks_apiserver_url         = module.uat_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-u-${each.value.regions[1]}-uat-aks-apiserver-url"].value,
      tf_second_uat_aks_azure_devops_sa_cacrt = module.uat_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-u-${each.value.regions[1]}-uat-aks-azure-devops-sa-cacrt"].value,
      tf_second_uat_aks_azure_devops_sa_token = base64decode(module.uat_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-u-${each.value.regions[1]}-uat-aks-azure-devops-sa-token"].value),
      tf_second_aks_uat_name                  = "pagopa-u-${each.value.regions[1]}-uat-aks"
    } : {},
    contains(each.value.envs, "p") && try(each.value.key_vaults, {}) != {} ? {
      tf_prod_aks_apiserver_url         = module.prod_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-p-${each.value.regions[0]}-prod-aks-apiserver-url"].value,
      tf_prod_aks_azure_devops_sa_cacrt = module.prod_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-p-${each.value.regions[0]}-prod-aks-azure-devops-sa-cacrt"].value,
      tf_prod_aks_azure_devops_sa_token = base64decode(module.prod_secrets["${each.value.name}-${each.value.regions[0]}"].values["pagopa-p-${each.value.regions[0]}-prod-aks-azure-devops-sa-token"].value),
      tf_aks_prod_name                  = "pagopa-p-${each.value.regions[0]}-prod-aks"

    } : {},
    contains(each.value.envs, "p") && try(each.value.key_vaults, {}) != {} && length(each.value.regions) > 1 ? {
      tf_second_prod_aks_apiserver_url         = module.prod_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-p-${each.value.regions[1]}-prod-aks-apiserver-url"].value,
      tf_second_prod_aks_azure_devops_sa_cacrt = module.prod_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-p-${each.value.regions[1]}-prod-aks-azure-devops-sa-cacrt"].value,
      tf_second_prod_aks_azure_devops_sa_token = base64decode(module.prod_secrets["${each.value.name}-${each.value.regions[1]}"].values["pagopa-p-${each.value.regions[1]}-prod-aks-azure-devops-sa-token"].value),
      tf_second_aks_prod_name                  = "pagopa-p-${each.value.regions[1]}-prod-aks"
    } : {},
    local.base_iac_variables_deploy,
    try(local.definitions_variables[each.value.name].iac_variables_deploy, {})
  )

  variables_secret = merge(
    local.base_iac_variables_secret,
    try(local.definitions_variables[each.value.name].iac_variables_secrets_deploy, {})
  )

  service_connection_ids_authorization = [
    try(each.value.repository.name, "pagopa-infra") == "pagopa-infra-core" ? azuredevops_serviceendpoint_github.azure-devops-github-infra-core-ro.id : azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,

    module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
    module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_id,
  ]

  schedules = try(each.value.schedules, null)
}
