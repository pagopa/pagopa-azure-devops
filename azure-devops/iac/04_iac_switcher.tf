variable "switcher_iac" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "eng-common-scripts"
      branch_name     = "refs/heads/main"
      pipelines_path  = "devops"
      yml_prefix_name = null
    }
    pipeline = {
      enable = true
      path   = "switcher"
    }
  }
}

  locals {
  # deploy vars
  iac-variables_switcher = {
    TF_AZURE_SERVICE_CONNECTION_NAME = azuredevops_serviceendpoint_azurerm.DEV-SERVICE-CONN.service_endpoint_name
    TF_AZURE_DEVOPS_POOL_AGENT_NAME : "pagopa-dev-linux-infra"
  }
  # deploy secrets
  iac-variables_secret_switcher = {}

}



#
# SWITCHER
#
module "iac_resource_switcher" {
  providers = {
    azurerm = azurerm.dev
  }

  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_resource_switcher?ref=v3.8.0"
  path   = var.switcher_iac.pipeline.path

  project_id                   = azuredevops_project.project.id
  repository                   = var.switcher_iac.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-rw.id

  variables = merge(
    local.iac_core-variables,
    local.iac-variables_switcher,
  )

  variables_secret = merge(
    local.iac_core-variables_secret,
    local.iac-variables_secret_switcher

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




