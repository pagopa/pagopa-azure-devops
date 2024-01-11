variable "pagopa-proxy" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "io-pagopa-proxy"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pagopa"
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
    }
  }
}

locals {
  # global vars
  pagopa-proxy-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-proxy.repository.branch_name
  }
  # global secrets
  pagopa-proxy-variables_secret = {

  }
  # code_review vars
  pagopa-proxy-variables_code_review = {
    danger_github_api_token = "skip"
  }
  # code_review secrets
  pagopa-proxy-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-proxy-variables_deploy = {
    github_connection       = local.srv_endpoint_github_rw
    dev_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name
  }
  # deploy secrets
  pagopa-proxy-variables_secret_deploy = {
    git_mail                          = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username                      = module.secrets.values["azure-devops-github-USERNAME"].value
    checkout_apim_v1_subscription_key = module.secrets.values["CHECKOUT-TEST-V1-SUBSCRIPTION-KEY"].value
    checkout_apim_v2_subscription_key = module.secrets.values["CHECKOUT-TEST-V2-SUBSCRIPTION-KEY"].value
  }
}

module "pagopa-proxy_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.5"
  count  = var.pagopa-proxy.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-proxy.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id
  path                         = "${local.domain}\\io-pagopa-proxy"

  variables = merge(
    local.pagopa-proxy-variables,
    local.pagopa-proxy-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-proxy-variables_secret,
    local.pagopa-proxy-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  ]
}

module "pagopa-proxy_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.5"
  count  = var.pagopa-proxy.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-proxy.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id
  path                         = "${local.domain}\\io-pagopa-proxy"

  variables = merge(
    local.pagopa-proxy-variables,
    local.pagopa-proxy-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-proxy-variables_secret,
    local.pagopa-proxy-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
  ]
}
