##################################################
# HOW TO DEFINE A NEW APPLICATION PIPELINE?
# have a look at 99_locals.tf
##################################################
module "code_review" {
  source   = "./.terraform/modules/__azdo__/azuredevops_build_definition_code_review"
  for_each = { for p in local.code_review_pipelines : p.name => p }

  project_id                   = data.azuredevops_project.project.id
  repository                   = each.value.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.github_qa.id
  path                         = each.value.pipeline_path
  pipeline_name_prefix         = each.value.pipeline_prefix

  variables        = try(local.pipelines_variables[each.value.name].variables_cr, {})
  variables_secret = try(local.pipelines_variables[each.value.name].variables_secrets_cr, {})

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.github_qa.id,
  ]
}

module "deploy" {
  source   = "./.terraform/modules/__azdo__/azuredevops_build_definition_deploy"
  for_each = { for p in local.deploy_pipelines : p.name => p }

  project_id                   = data.azuredevops_project.project.id
  repository                   = each.value.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.github_qa.id
  path                         = each.value.pipeline_path
  pipeline_name_prefix         = each.value.pipeline_prefix

  variables = merge(
    local.base_app_variables,
    try(local.pipelines_variables[each.value.name].variables_deploy, {}),
  )

  # in case we wanted to use secrets from keyvault
  variables_secret = merge(
    try(local.pipelines_variables[each.value.name].variables_secrets_deploy, {}),
    contains(each.value.envs, "d") && try(each.value.kv_name, "") != "" ? {
      # placeholder      = module.dev_secrets[each.value.name].values["placeholder"].value
    } : {},
    contains(each.value.envs, "u") && try(each.value.kv_name, "") != "" ? {
      # placeholder      = module.uat_secrets[each.value.name].values["placeholder"].value
    } : {},
    contains(each.value.envs, "p") && try(each.value.kv_name, "") != "" ? {
      # placeholder      = module.prod_secrets[each.value.name].values["placeholder"].value
    } : {},
  )

  service_connection_ids_authorization = [
    azuredevops_serviceendpoint_github.github_qa.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
    data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.id,
  ]
}

# Grant all pipelines in the project access to UAT and PROD pools (same model as pagopa-dev-linux)
resource "azuredevops_pipeline_authorization" "uat_linux_pool" {
  project_id  = data.azuredevops_project.project.id
  resource_id = data.azuredevops_agent_queue.uat_linux.id
  type        = "queue"
}

resource "azuredevops_pipeline_authorization" "prod_linux_pool" {
  project_id  = data.azuredevops_project.project.id
  resource_id = data.azuredevops_agent_queue.prod_linux.id
  type        = "queue"
}
