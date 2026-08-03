##################################################
# HOW TO DEFINE A NEW APPLICATION PIPELINE?
# have a look at 99_locals.tf
##################################################
module "code_review" {
  source   = "./.terraform/modules/__azdo__/azuredevops_build_definition_code_review"
  for_each = { for p in local.code_review_pipelines : p.name => p }

  project_id                   = data.azuredevops_project.project.id
  repository                   = each.value.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_pr.id
  path                         = each.value.pipeline_path
  pipeline_name_prefix         = each.value.pipeline_prefix

  variables        = try(local.pipelines_variables[each.value.name].variables_cr, {})
  variables_secret = try(local.pipelines_variables[each.value.name].variables_secrets_cr, {})

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
  ]
}

module "deploy" {
  source   = "./.terraform/modules/__azdo__/azuredevops_build_definition_deploy"
  for_each = { for p in local.deploy_pipelines : p.name => p }

  project_id                   = data.azuredevops_project.project.id
  repository                   = each.value.repository
  github_service_connection_id = data.azuredevops_serviceendpoint_github.github_rw.id
  path                         = each.value.pipeline_path
  pipeline_name_prefix         = each.value.pipeline_prefix

  variables = merge(
    local.base_app_variables,
    try(local.pipelines_variables[each.value.name].variables_deploy, {}),
  )

  variables_secret = try(local.pipelines_variables[each.value.name].variables_secrets_deploy, {})

  service_connection_ids_authorization = [
    data.azuredevops_serviceendpoint_github.github_ro.id,
    data.azuredevops_serviceendpoint_azurerm.dev.id,
    data.azuredevops_serviceendpoint_azurerm.uat.id,
    data.azuredevops_serviceendpoint_azurerm.prod.id,
    data.azuredevops_serviceendpoint_azurecr.dev_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.uat_ita_workload_identity.id,
    data.azuredevops_serviceendpoint_azurecr.prod_ita_workload_identity.id,
  ]
}
