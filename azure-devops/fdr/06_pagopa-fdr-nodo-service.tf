variable "pagopa-fdr-nodo-service" {
  default = {
    repository = {
      organization    = "pagopa"
      name            = "pagopa-fdr-nodo-dei-pagamenti"
      branch_name     = "refs/heads/main"
      pipelines_path  = ".devops"
      yml_prefix_name = null
    }
    pipeline = {
      suspend_job = {
        enabled               = true
        name                  = "suspend-job-pipeline"
        pipeline_yml_filename = "suspend-job-pipelines.yml"
      },
      performance_test = {
        enabled               = true
        name                  = "performance-test-pipeline"
        pipeline_yml_filename = "performance-test-pipelines.yaml"
      }
    }
  }
}

locals {
  # global vars
  pagopa-fdr-nodo-service-variables = {
    cache_version_id = "v1"
    default_branch   = var.pagopa-fdr-nodo-service.repository.branch_name
  }
  # global secrets
  pagopa-fdr-nodo-service-variables_secret = {
  }
  # integration vars
  pagopa-fdr-nodo-service-variables_integration_test = {
    github_connection               = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tf_dev_azure_service_connection = "io-azure-devops-github-rw"
  }
  # integration secrets
  pagopa-fdr-nodo-service-variables_secret_integration_test = {
  }
  # performance vars
  pagopa-fdr-nodo-service-variables_performance_test = {
    github_connection               = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    tf_dev_azure_service_connection = "io-azure-devops-github-rw"
  }
  # performance secrets
  pagopa-fdr-nodo-service-variables_secret_performance_test = {
    DEV_API_SUBSCRIPTION_KEY = module.fdr_dev_secrets.values["fdr-phase-1-perf-test-subkey"].value
    UAT_API_SUBSCRIPTION_KEY = module.fdr_uat_secrets.values["fdr-phase-1-perf-test-subkey"].value
  }

  # suspend job vars
  pagopa-fdr-nodo-service-variables_suspend_job = {
    github_connection = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_name
    # aks section
    k8s_namespace               = "fdr"
    dev_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_dev.id
    uat_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_uat.id
    #    prod_kubernetes_service_conn = azuredevops_serviceendpoint_kubernetes.aks_prod.id

  }
  # suspend job secrets
  pagopa-fdr-nodo-service-variables_secret_suspend_job = {
  }
}

module "pagopa-fdr-nodo-service_suspend_job" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-fdr-nodo-service.pipeline.suspend_job.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-fdr-nodo-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  # github_service_connection_id = data.azuredevops_serviceendpoint_github.github_ro.id
  path                  = "${local.domain}\\pagopa-fdr-nodo-service"
  pipeline_name         = var.pagopa-fdr-nodo-service.pipeline.suspend_job.name
  pipeline_yml_filename = var.pagopa-fdr-nodo-service.pipeline.suspend_job.pipeline_yml_filename

  variables = merge(
    local.pagopa-fdr-nodo-service-variables,
    local.pagopa-fdr-nodo-service-variables_suspend_job,
  )

  variables_secret = merge(
    local.pagopa-fdr-nodo-service-variables_secret,
    local.pagopa-fdr-nodo-service-variables_secret_suspend_job,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}

module "pagopa-fdr-nodo-service_performance_test" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=v4.2.1"
  count  = var.pagopa-fdr-nodo-service.pipeline.performance_test.enabled == true ? 1 : 0

  project_id                   = data.azuredevops_project.project.id
  repository                   = var.pagopa-fdr-nodo-service.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.service_endpoint_id
  path                         = "${local.domain}\\pagopa-fdr-nodo-service"
  pipeline_name                = var.pagopa-fdr-nodo-service.pipeline.performance_test.name
  pipeline_yml_filename        = var.pagopa-fdr-nodo-service.pipeline.performance_test.pipeline_yml_filename

  variables = merge(
    local.pagopa-fdr-nodo-service-variables,
    local.pagopa-fdr-nodo-service-variables_performance_test,
  )

  variables_secret = merge(
    local.pagopa-fdr-nodo-service-variables_secret,
    local.pagopa-fdr-nodo-service-variables_secret_performance_test,
  )

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}
