# variable "pagopa-wallet-tests" {
#   default = {
#     repository = {
#       organization    = "pagopa"
#       name            = "pagopa-wallet-tests"
#       branch_name     = "refs/heads/main"
#       pipelines_path  = ".devops"
#       yml_prefix_name = null
#     }
#     pipeline = {
#       enable_code_review = true
#     }
#   }
# }

# locals {
#   # global vars
#   pagopa-wallet-tests-variables = {
#     cache_version_id = "v1"
#     default_branch   = var.pagopa-wallet-tests.repository.branch_name
#   }
#   # global secrets
#   pagopa-wallet-tests-variables_secret = {

#   }
#   # code_review vars
#   pagopa-wallet-tests-variables_code_review = {
#     danger_github_api_token = "skip"
#   }
#   # api-tests secrets
#   pagopa-wallet-tests-variables_secret_code_review = {
#     user_wallet_token_dev = module.wallet_dev_secrets.values["wallet-token-test-key"].value
#     user_wallet_token_uat = module.wallet_uat_secrets.values["wallet-token-test-key"].value
#   }
# }

# module "pagopa-wallet-tests_code_review" {
#   source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v5.1.1"
#   count  = var.pagopa-wallet-tests.pipeline.enable_code_review == true ? 1 : 0

#   project_id                   = data.azuredevops_project.project.id
#   repository                   = var.pagopa-wallet-tests.repository
#   github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id

#   path = "${local.domain}\\pagopa-wallet-tests"

#   variables = merge(
#     local.pagopa-wallet-tests-variables,
#     local.pagopa-wallet-tests-variables_code_review,
#   )

#   variables_secret = merge(
#     local.pagopa-wallet-tests-variables_secret,
#     local.pagopa-wallet-tests-variables_secret_code_review,
#   )

#   service_connection_ids_authorization = [
#     data.azuredevops_serviceendpoint_github.github_ro.id,
#   ]
# }
