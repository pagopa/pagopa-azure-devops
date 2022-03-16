# variable "pagopa-reporting-fdr" {
#   default = {
#     repository = {
#       organization    = "pagopa"
#       name            = "pagopa-reporting-fdr"
#       branch_name     = "main"
#       pipelines_path  = ".devops"
#       yml_prefix_name = "pagopa"
#     }
#     pipeline = {
#       enable_code_review = true
#       enable_deploy      = true
#       sonarcloud = {
#         # TODO azure devops terraform provider does not support SonarCloud service endpoint
#         service_connection = "SONARCLOUD-SERVICE-CONN"
#         org                = "pagopa"
#         project_key        = "pagopa_pagopa-reporting-fdr"
#         project_name       = "pagopa-reporting-fdr"
#       }

#     }
#   }
# }

# locals {
#   # global vars
#   pagopa-reporting-fdr-variables = {
#     cache_version_id = "v1"
#     default_branch   = var.pagopa-reporting-fdr.repository.branch_name
#   }
#   # global secrets
#   pagopa-reporting-fdr-variables_secret = {

#   }
#   # code_review vars
#   pagopa-reporting-fdr-variables_code_review = {
#     sonarcloud_service_conn = var.pagopa-reporting-fdr.pipeline.sonarcloud.service_connection
#     sonarcloud_org          = var.pagopa-reporting-fdr.pipeline.sonarcloud.org
#     sonarcloud_project_key  = var.pagopa-reporting-fdr.pipeline.sonarcloud.project_key
#     sonarcloud_project_name = var.pagopa-reporting-fdr.pipeline.sonarcloud.project_name
#     danger_github_api_token = "skip"
#   }
#   # code_review secrets
#   pagopa-reporting-fdr-variables_secret_code_review = {

#   }
#   # deploy vars
#   pagopa-reporting-fdr-variables_deploy = {
#     git_mail                = module.secrets.values["azure-devops-github-EMAIL"].value
#     git_username            = module.secrets.values["azure-devops-github-USERNAME"].value
#     github_connection       = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name

#     healthcheck_endpoint             = "/api/v1/info"
#     dev_deploy_type                  = "production_slot" #or staging_slot_and_swap
#     dev_azure_subscription           = azuredevops_serviceendpoint_azurerm.DEV-PAGOPA.service_endpoint_name
#     dev_web_app_name                 = "pagopa-d-fn-reportingfdr"
#     dev_web_app_resource_group_name  = "pagopa-d-reporting-fdr-rg"
#     uat_deploy_type                  = "production_slot" #or staging_slot_and_swap
#     uat_azure_subscription           = azuredevops_serviceendpoint_azurerm.UAT-PAGOPA.service_endpoint_name
#     uat_web_app_name                 = "pagopa-u-fn-reportingfdr"
#     uat_web_app_resource_group_name  = "pagopa-u-reporting-fdr-rg"
#     prod_deploy_type                 = "production_slot" #or staging_slot_and_swap
#     prod_azure_subscription          = azuredevops_serviceendpoint_azurerm.PROD-PAGOPA.service_endpoint_name
#     prod_web_app_name                = "pagopa-p-fn-reportingfdr"
#     prod_web_app_resource_group_name = "pagopa-p-reporting-fdr-rg"

#     tenant_id                         = module.secrets.values["TENANTID"].value

#     # acr section
#     image_repository = "reporting-fdr"

#     dev_container_registry  = azuredevops_serviceendpoint_azurecr.pagopa-azurecr-dev.service_endpoint_name
#     uat_container_registry  = azuredevops_serviceendpoint_azurecr.pagopa-azurecr-uat.service_endpoint_name
#     prod_container_registry = azuredevops_serviceendpoint_azurecr.pagopa-azurecr-prod.service_endpoint_name

#     dev_container_namespace  = "pagopadacr.azurecr.io"
#     uat_container_namespace  = "pagopauacr.azurecr.io"
#     prod_container_namespace = "pagopapacr.azurecr.io"

#   }
#   # deploy secrets
#   pagopa-reporting-fdr-variables_secret_deploy = {

#   }
# }

# module "pagopa-reporting-fdr_code_review" {
#   source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
#   count  = var.pagopa-reporting-fdr.pipeline.enable_code_review == true ? 1 : 0

#   project_id                   = azuredevops_project.project.id
#   repository                   = var.pagopa-reporting-fdr.repository
#   github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

#   variables = merge(
#     local.pagopa-reporting-fdr-variables,
#     local.pagopa-reporting-fdr-variables_code_review,
#   )

#   variables_secret = merge(
#     local.pagopa-reporting-fdr-variables_secret,
#     local.pagopa-reporting-fdr-variables_secret_code_review,
#   )

#   service_connection_ids_authorization = [
#     azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
#     local.azuredevops_serviceendpoint_sonarcloud_id,
#   ]
# }

# module "pagopa-reporting-fdr_deploy" {
#   source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
#   count  = var.pagopa-reporting-fdr.pipeline.enable_deploy == true ? 1 : 0

#   project_id                   = azuredevops_project.project.id
#   repository                   = var.pagopa-reporting-fdr.repository
#   github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

#   variables = merge(
#     local.pagopa-reporting-fdr-variables,
#     local.pagopa-reporting-fdr-variables_deploy,
#   )

#   variables_secret = merge(
#     local.pagopa-reporting-fdr-variables_secret,
#     local.pagopa-reporting-fdr-variables_secret_deploy,
#   )

#   service_connection_ids_authorization = [
#     azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
#     azuredevops_serviceendpoint_azurerm.DEV-PAGOPA.id,
#     azuredevops_serviceendpoint_azurerm.UAT-PAGOPA.id,
#     azuredevops_serviceendpoint_azurerm.PROD-PAGOPA.id,
#   ]
# }
