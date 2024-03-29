# variable "iac_aks_platform" {
#   default = {
#     repository = {
#       organization    = "pagopa"
#       name            = "pagopa-infra"
#       branch_name     = "refs/heads/main"
#       pipelines_path  = ".devops"
#       yml_prefix_name = "aks-platform"
#     }
#     pipeline = {
#       enable_code_review = true
#       enable_deploy      = true
#       path_name          = "aks-platform-infra"
#     }
#   }
# }

# locals {
#   # global vars
#   iac_aks_platform-variables = {
#     TF_POOL_NAME_DEV : "pagopa-dev-linux-infra",
#     TF_POOL_NAME_UAT : "pagopa-uat-linux-infra",
#     TF_POOL_NAME_PROD : "pagopa-prod-linux-infra",

#     tf_dev_aks_apiserver_url         = module.elk_dev_secrets.values["pagopa-d-weu-dev-aks-apiserver-url"].value,
#     tf_dev_aks_azure_devops_sa_cacrt = module.elk_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-cacrt"].value,
#     tf_dev_aks_azure_devops_sa_token = base64decode(module.elk_dev_secrets.values["pagopa-d-weu-dev-aks-azure-devops-sa-token"].value),
#     tf_aks_dev_name                  = var.aks_dev_platform_name

#     tf_uat_aks_apiserver_url         = module.elk_uat_secrets.values["pagopa-u-weu-uat-aks-apiserver-url"].value,
#     tf_uat_aks_azure_devops_sa_cacrt = module.elk_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-cacrt"].value,
#     tf_uat_aks_azure_devops_sa_token = base64decode(module.elk_uat_secrets.values["pagopa-u-weu-uat-aks-azure-devops-sa-token"].value),
#     tf_aks_uat_name                  = var.aks_uat_platform_name

#     tf_prod_aks_apiserver_url         = module.elk_prod_secrets.values["pagopa-p-weu-prod-aks-apiserver-url"].value,
#     tf_prod_aks_azure_devops_sa_cacrt = module.elk_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-cacrt"].value,
#     tf_prod_aks_azure_devops_sa_token = base64decode(module.elk_prod_secrets.values["pagopa-p-weu-prod-aks-azure-devops-sa-token"].value),
#     tf_aks_prod_name                  = var.aks_prod_platform_name
#   }
#   # global secrets
#   iac_aks_platform-variables_secret = {

#   }

#   # code_review vars
#   iac_aks_platform-variables_code_review = {
#     TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV : module.DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_name,
#     TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_UAT : module.UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_name,
#     TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_PROD : module.PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_name,
#   }
#   # code_review secrets
#   iac_aks_platform-variables_secret_code_review = {

#   }

#   # deploy vars
#   iac_aks_platform-variables_deploy = {
#     #APPLY
#     TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV : azuredevops_serviceendpoint_azurerm.DEV-PAGOPA-IAC-LEGACY.service_endpoint_name,
#     TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT : azuredevops_serviceendpoint_azurerm.UAT-PAGOPA-IAC-LEGACY.service_endpoint_name,
#     TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD : azuredevops_serviceendpoint_azurerm.PROD-PAGOPA-IAC-LEGACY.service_endpoint_name,

#   }
#   # deploy secrets
#   iac_aks_platform-variables_secret_deploy = {

#   }
# }

# #
# # Code review
# #
# module "iac_aks_platform_code_review" {
#   source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v7.0.0"
#   count  = var.iac_aks_platform.pipeline.enable_code_review == true ? 1 : 0

#   project_id                   = azuredevops_project.project.id
#   repository                   = var.iac_aks_platform.repository
#   github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
#   path                         = var.iac_aks_platform.pipeline.path_name
#     pipeline_name_prefix         = var.iac_aks_platform.repository.yml_prefix_name


#

#   variables = merge(
#     local.iac_aks_platform-variables,
#     local.iac_aks_platform-variables_code_review,
#   )

#   variables_secret = merge(
#     local.iac_aks_platform-variables_secret,
#     local.iac_aks_platform-variables_secret_code_review,
#   )

#   service_connection_ids_authorization = [
#     azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
#     module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
#     module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
#     module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
#   ]
# }

# #
# # DEPLOY
# #
# module "iac_aks_platform_deploy" {
#   source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v7.0.0"
#   count  = var.iac_aks_platform.pipeline.enable_deploy == true ? 1 : 0

#   project_id                   = azuredevops_project.project.id
#   repository                   = var.iac_aks_platform.repository
#   github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
#   path                         = var.iac_aks_platform.pipeline.path_name
#     pipeline_name_prefix         = var.iac_aks_platform.repository.yml_prefix_name


#   ci_trigger_use_yaml           = false
#   pull_request_trigger_use_yaml = false


#   variables = merge(
#     local.iac_aks_platform-variables,
#     local.iac_aks_platform-variables_deploy,
#     local.iac_aks_platform-variables_code_review,
#   )

#   variables_secret = merge(
#     local.iac_aks_platform-variables_secret,
#     local.iac_aks_platform-variables_secret_deploy,
#   )

#   service_connection_ids_authorization = [
#     azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
#     module.DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_id,
#     module.UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_id,
#     module.PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_id,

#     azuredevops_serviceendpoint_azurerm.DEV-PAGOPA-IAC-LEGACY.id,
#     azuredevops_serviceendpoint_azurerm.UAT-PAGOPA-IAC-LEGACY.id,
#     azuredevops_serviceendpoint_azurerm.PROD-PAGOPA-IAC-LEGACY.id,
#   ]
# }
