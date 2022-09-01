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

  }
  # deploy vars
  pagopa-checkout-fe-variables_deploy = {
    git_mail                 = module.secrets.values["azure-devops-github-EMAIL"].value
    git_username             = module.secrets.values["azure-devops-github-USERNAME"].value
    github_connection        = azuredevops_serviceendpoint_github.azure-devops-github-rw.service_endpoint_name
    dev_azure_subscription   = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    uat_azure_subscription   = azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.service_endpoint_name
    prod_azure_subscription  = azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.service_endpoint_name
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
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.0.4"
  count  = var.pagopa-checkout-fe.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-checkout-fe.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id

  variables = merge(
    local.pagopa-checkout-fe-variables,
    local.pagopa-checkout-fe-variables_code_review,
  )

  variables_secret = merge(
    local.pagopa-checkout-fe-variables_secret,
    local.pagopa-checkout-fe-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id
  ]
}

module "pagopa-checkout-fe_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.0.4"
  count  = var.pagopa-checkout-fe.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.pagopa-checkout-fe.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.pagopa-checkout-fe-variables,
    local.pagopa-checkout-fe-variables_deploy,
  )

  variables_secret = merge(
    local.pagopa-checkout-fe-variables_secret,
    local.pagopa-checkout-fe-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}
