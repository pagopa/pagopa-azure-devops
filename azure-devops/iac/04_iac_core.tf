variable "iac_core" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-infra"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = "core"
    }
    switcher_repository = {
      organization    = "pagopa"
      name            = "eng-common-scripts"
      branch_name     = "refs/heads/main"
      pipelines_path  = "devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable_code_review = true
      enable_deploy      = true
      enable_switcher    = true
      path_name          = "core-infra"
    }
  }
}

locals {
  # global vars
  iac_core-variables = {

  }
  # global secrets
  iac_core-variables_secret = {

  }

  # code_review vars
  iac_core-variables_code_review = {

  }
  # code_review secrets
  iac_core-variables_secret_code_review = {

  }

  # deploy vars
  iac_core-variables_deploy = {

  }
  # deploy secrets
  iac_core-variables_secret_deploy = {

  }

  # switcher vars
  iac_core-variables_switcher = {

  }
  # switcher secrets
  iac_core-variables_secret_switcher = {

  }
}

#
# Code review
#
module "iac_core_code_review" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=v2.6.3"
  count  = var.iac_core.pipeline.enable_code_review == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.iac_core.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.iac_core.pipeline.path_name

  pull_request_trigger_use_yaml = true

  variables = merge(
    local.iac_core-variables,
    local.iac_core-variables_code_review,
  )

  variables_secret = merge(
    local.iac_core-variables_secret,
    local.iac_core-variables_secret_code_review,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}

#
# DEPLOY
#
module "iac_core_deploy" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=v2.6.3"
  count  = var.iac_core.pipeline.enable_deploy == true ? 1 : 0

  project_id                   = azuredevops_project.project.id
  repository                   = var.iac_core.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-pr.id
  path                         = var.iac_core.pipeline.path_name

  ci_trigger_use_yaml           = false
  pull_request_trigger_use_yaml = false


  variables = merge(
    local.iac_core-variables,
    local.iac_core-variables_deploy,
  )

  variables_secret = merge(
    local.iac_core-variables_secret,
    local.iac_core-variables_secret_deploy,
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.UAT-SERVICE-CONN.id,
    azuredevops_serviceendpoint_azurerm.PROD-SERVICE-CONN.id,
  ]
}


#
# SWITCHER
#
module "iac_resource_switcher" {
  provider = azurerm.dev

  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_resource_switcher?ref=67564b6"
  count  = var.iac_core.pipeline.enable_switcher == true ? 1 : 0
  path   = var.iac_core.pipeline.path_name

  project_id                   = azuredevops_project.project.id
  repository                   = var.iac_core.switcher_repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.iac_core-variables,
    local.iac_core-variables_switcher,
  )

  variables_secret = merge(
    local.iac_core-variables_secret,
    local.iac_core-variables_secret_switcher
  )


  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.azure-devops-github-ro.id,
    azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.id,
  ]

  schedule_configuration = {
    days_to_build = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    timezone = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = ["main"]
      exclude = []
    }
    aks = [
      {
        cluster_name = "pagopa-d-neu-dev-aks"
        rg = "pagopa-d-neu-dev-aks-rg"
        start_time = "08:00"
        stop_time = "20:00"
        user = {
          nodes_on_start = "1,5"
          nodes_on_stop = "0,0"
        }
        system = {
          nodes_on_start = "1,3"
          nodes_on_stop = "1,1"
        }
      },
      {
        cluster_name = "pagopa-d-weu-dev-aks"
        rg = "pagopa-d-weu-dev-aks-rg"
        start_time = "08:00"
        stop_time = "20:00"
        user = {
          nodes_on_start = "1,5"
          nodes_on_stop = "0,0"
        }
        system = {
          nodes_on_start = "1,3"
          nodes_on_stop = "1,1"
        }
      }
    ]
    sa_sftp = []
  }
}




