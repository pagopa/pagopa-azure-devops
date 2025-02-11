# variable "iac_checkout" {
#   default = {
#     repository = {
#       organization    = "pagopa"
#       name            = "pagopa-infra"
#       branch_name     = "refs/heads/main"
#       pipelines_path  = ".devops"
#       yml_prefix_name = "checkout"
#     }
#     pipeline = {
#       enable_code_review = true
#       enable_deploy      = true
#       path_name          = "checkout-infra"
#     }
#   }
# }
#
# locals {
#   # global vars
#   iac_checkout-variables = {
#     TF_POOL_NAME_DEV : "pagopa-dev-linux-infra",
#     TF_POOL_NAME_UAT : "pagopa-uat-linux-infra",
#     TF_POOL_NAME_PROD : "pagopa-prod-linux-infra",
#
#     #PLAN
#     TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV  = module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
#     TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_UAT  = module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
#     TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_PROD = module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_name,
#     #APPLY
#     TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV  = module.DEV-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
#     TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_UAT  = module.UAT-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
#     TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_PROD = module.PROD-AZURERM-IAC-DEPLOY-SERVICE-CONN.service_endpoint_name,
#
#   }
#   # global secrets
#   iac_checkout-variables_secret = {
#
#   }
#
#   # code_review vars
#   iac_checkout-variables_code_review = {
#   }
#   # code_review secrets
#   iac_checkout-variables_secret_code_review = {
#
#   }
#
#   # deploy vars
#   iac_checkout-variables_deploy = {}
#   # deploy secrets
#   iac_checkout-variables_secret_deploy = {
#
#   }
# }
#
# #
# # Code review
# #
# module "iac_checkout_code_review" {
#   source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v7.0.0"
#   count  = var.iac_checkout.pipeline.enable_code_review == true ? 1 : 0
#
#   project_id                   = azuredevops_project.project.id
#   repository                   = var.iac_checkout.repository
#   github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
#   path                         = var.iac_checkout.pipeline.path_name
#   pipeline_name_prefix         = var.iac_checkout.repository.yml_prefix_name
#
#
#
#
#   variables = merge(
#     local.iac_checkout-variables,
#     local.iac_checkout-variables_code_review,
#   )
#
#   variables_secret = merge(
#     local.iac_checkout-variables_secret,
#     local.iac_checkout-variables_secret_code_review,
#   )
#
#   service_connection_ids_authorization = [
#     azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
#     module.DEV-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
#     module.UAT-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
#     module.PROD-AZURERM-IAC-PLAN-SERVICE-CONN.service_endpoint_id,
#   ]
# }
#
# #
# # DEPLOY
# #
# module "iac_checkout_deploy" {
#   source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v7.0.0"
#   count  = var.iac_checkout.pipeline.enable_deploy == true ? 1 : 0
#
#   project_id                   = azuredevops_project.project.id
#   repository                   = var.iac_checkout.repository
#   github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
#   path                         = var.iac_checkout.pipeline.path_name
#   pipeline_name_prefix         = var.iac_checkout.repository.yml_prefix_name
#
#
#
#
#   variables = merge(
#     local.iac_checkout-variables,
#     local.iac_checkout-variables_deploy,
#   )
#
#   variables_secret = merge(
#     local.iac_checkout-variables_secret,
#     local.iac_checkout-variables_secret_deploy,
#   )
#
#   service_connection_ids_authorization = [
#     azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
#     module.DEV-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_id,
#     module.UAT-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_id,
#     module.PROD-PAGOPA-IAC-LEGACY-PLAN-SERVICE-CONN.service_endpoint_id,
#
#     azuredevops_serviceendpoint_azurerm.DEV-PAGOPA-IAC-LEGACY.id,
#     azuredevops_serviceendpoint_azurerm.UAT-PAGOPA-IAC-LEGACY.id,
#     azuredevops_serviceendpoint_azurerm.PROD-PAGOPA-IAC-LEGACY.id,
#   ]
# }
