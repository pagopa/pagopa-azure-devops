variable "pagopa-payment-wallet-fe" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-wallet-fe"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "pagopa"
    }
  }
}

locals {
  # global vars
  pagopa-payment-wallet-fe-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-payment-wallet-fe.repository.branch_name
  }
  # global secrets
  pagopa-payment-wallet-fe-variables_secret = {

  }
  # code_review vars
  pagopa-payment-wallet-fe-variables_code_review = {

  }
  # code_review secrets
  pagopa-payment-wallet-fe-variables_secret_code_review = {

  }
  # deploy vars
  pagopa-payment-wallet-fe-variables_deploy = {
    github_connection       = local.srv_endpoint_github_rw
    dev_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name
    cache_version_id        = "v1"
    api_host_dev            = "https://api.dev.platform.pagopa.it"
    api_host_uat            = "https://api.uat.platform.pagopa.it"
    api_host_prod           = "https://api.platform.pagopa.it"
  }
  # deploy secrets
  pagopa-payment-wallet-fe-variables_secret_deploy = {
    git_mail     = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username = module.secrets.values["azure-devops-github-USERNAME"].value
  }
}

module "pagopa-payment-wallet-fe_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.2.0"

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-payment-wallet-fe.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id

  path = "${local.domain}\\pagopa-payment-wallet-fe"

  variables = merge(
    local.pagopa-payment-wallet-fe-variables,
    local.pagopa-payment-wallet-fe-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-payment-wallet-fe-variables_secret,
    local.pagopa-payment-wallet-fe-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  ]
}

module "pagopa-payment-wallet-fe_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-payment-wallet-fe.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id

  path = "${local.domain}\\pagopa-payment-wallet-fe"

  variables = merge(
    local.pagopa-payment-wallet-fe-variables,
    local.pagopa-payment-wallet-fe-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-payment-wallet-fe-variables_secret,
    local.pagopa-payment-wallet-fe-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    #data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
  ]
}
