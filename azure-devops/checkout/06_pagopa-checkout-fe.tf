variable "pagopa-checkout-fe" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-checkout-fe"
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
  pagopa-checkout-fe-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-checkout-fe.repository.branch_name
  }
  # global secrets
  pagopa-checkout-fe-variables_secret = {

  }
  # code_review vars
  pagopa-checkout-fe-variables_code_review = {
    danger_github_api_token = "skip"
  }
  # code_review secrets
  pagopa-checkout-fe-variables_secret_code_review = {
    checkout-test-npg-api-key = module.secrets.values["checkout-test-npg-api-key"].value
  }
  # deploy vars
  pagopa-checkout-fe-variables_deploy = {
    git_mail                 = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username             = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection        = local.srv_endpoint_github_rw
    dev_azure_subscription   = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription   = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name
    cache_version_id         = "v1"
    checkout_api_host_dev    = "https://api.dev.platform.pagopa.it"
    checkout_api_host_uat    = "https://api.uat.platform.pagopa.it"
    checkout_api_host_prod   = "https://api.platform.pagopa.it"
    checkout_captcha_id_dev  = module.secrets.values["DEV-CHECKOUT-CAPTCHA-ID"].value
    checkout_captcha_id_uat  = module.secrets.values["UAT-CHECKOUT-CAPTCHA-ID"].value
    checkout_captcha_id_prod = module.secrets.values["PROD-CHECKOUT-CAPTCHA-ID"].value
  }
  # deploy secrets
  pagopa-checkout-fe-variables_secret_deploy = {

  }
}

module "pagopa-checkout-fe_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v4.1.5"
  count  = var.pagopa-checkout-fe.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-checkout-fe.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id

  path = "${local.domain}\\pagopa-checkout-fe"

  variables = merge(
    local.pagopa-checkout-fe-variables,
    local.pagopa-checkout-fe-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-checkout-fe-variables_secret,
    local.pagopa-checkout-fe-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  ]
}

module "pagopa-checkout-fe_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v4.1.5"
  count  = var.pagopa-checkout-fe.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-checkout-fe.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id

  path = "${local.domain}\\pagopa-checkout-fe"

  variables = merge(
    local.pagopa-checkout-fe-variables,
    local.pagopa-checkout-fe-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-checkout-fe-variables_secret,
    local.pagopa-checkout-fe-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
  ]
}
