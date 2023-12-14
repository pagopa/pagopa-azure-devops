variable "pagopa-ecommerce-fe" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-ecommerce-fe"
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
  pagopa-ecommerce-fe-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-ecommerce-fe.repository.branch_name
  }
  # global secrets
  pagopa-ecommerce-fe-variables_secret = {

  }
  # code_review vars
  pagopa-ecommerce-fe-variables_code_review = {
    danger_github_api_token = "skip"
  }
  # code_review secrets
  pagopa-ecommerce-fe-variables_secret_code_review = {
  }
  # deploy vars
  pagopa-ecommerce-fe-variables_deploy = {
    git_mail                = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username            = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection       = local.srv_endpoint_github_rw
    dev_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_name
    uat_azure_subscription  = data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_name
    prod_azure_subscription = data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_name
    cache_version_id        = "v1"
    ecommerce_api_host_dev  = "https://api.dev.platform.pagopa.it"
    ecommerce_api_host_uat  = "https://api.uat.platform.pagopa.it"
    ecommerce_api_host_prod = "https://api.platform.pagopa.it"
  }
  # deploy secrets
  pagopa-ecommerce-fe-variables_secret_deploy = {

  }
}

module "pagopa-ecommerce-fe_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.2.0"
  count  = var.pagopa-ecommerce-fe.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-fe.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_pr_id

  path = "${local.domain}\\pagopa-ecommerce-fe"

  variables = merge(
    local.pagopa-ecommerce-fe-variables,
    local.pagopa-ecommerce-fe-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-fe-variables_secret,
    local.pagopa-ecommerce-fe-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id
  ]
}

module "pagopa-ecommerce-fe_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.2.0"
  count  = var.pagopa-ecommerce-fe.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-ecommerce-fe.repository
  github_service_connection_id = data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_rw_id

  path = "${local.domain}\\pagopa-ecommerce-fe"

  variables = merge(
    local.pagopa-ecommerce-fe-variables,
    local.pagopa-ecommerce-fe-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-ecommerce-fe-variables_secret,
    local.pagopa-ecommerce-fe-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    data.terraform_remote_state.app.outputs.service_endpoint_azure_devops_github_ro_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_dev_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_uat_id,
    data.terraform_remote_state.app.outputs.service_endpoint_azure_prod_id,
  ]
}
