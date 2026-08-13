module "github_token" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query?ref=33777a27f8f917a96220f5cf8fb3c3eee8e594b0"

  providers = {
    azurerm = azurerm
  }

  resource_group = var.github_token_key_vault_resource_group
  key_vault_name = var.github_token_key_vault_name

  secrets = [var.github_token_secret_name]
}

resource "azuredevops_serviceendpoint_github" "this" {
  depends_on = [module.github_token]

  project_id            = var.project_id
  service_endpoint_name = var.github_service_connection_name

  auth_personal {
    personal_access_token = module.github_token.values[var.github_token_secret_name].value
  }

  lifecycle {
    ignore_changes = [description, authorization]
  }
}

locals {
  derived_code_review_pipelines = {
    for app_name, app in var.applications :
    "${app_name}_code_review" => {
      kind                                 = "code_review"
      repository                           = app.repository
      path                                 = app.path
      pipeline_prefix                      = app.pipeline_prefix
      pull_request_trigger_use_yaml        = try(app.code_review.pull_request_trigger_use_yaml, true)
      variables                            = try(app.code_review.variables, {})
      variables_secret                     = try(app.code_review.variables_secret, {})
      service_connection_ids_authorization = try(app.code_review.service_connection_ids_authorization, [])
      queue_ids_to_authorize               = try(app.code_review.queue_ids_to_authorize, [])
    }
    if try(app.enable_code_review, true)
  }

  derived_deploy_pipelines = {
    for app_name, app in var.applications :
    "${app_name}_deploy" => {
      kind                                 = "deploy"
      repository                           = app.repository
      path                                 = app.path
      pipeline_prefix                      = app.pipeline_prefix
      variables                            = try(app.deploy.variables, {})
      variables_secret                     = try(app.deploy.variables_secret, {})
      service_connection_ids_authorization = try(app.deploy.service_connection_ids_authorization, [])
      queue_ids_to_authorize               = try(app.deploy.queue_ids_to_authorize, [])
    }
    if try(app.enable_deploy, true)
  }

  derived_generic_pipelines = {
    for item in flatten([
      for app_name, app in var.applications : [
        for generic_name, generic_pipeline in try(app.generic, {}) : {
          key = "${app_name}_${generic_name}"
          value = {
            kind                                 = "generic"
            repository                           = app.repository
            path                                 = app.path
            pipeline_name                        = generic_pipeline.pipeline_name
            pipeline_yml_filename                = generic_pipeline.pipeline_yml_filename
            variables                            = try(generic_pipeline.variables, {})
            variables_secret                     = try(generic_pipeline.variables_secret, {})
            service_connection_ids_authorization = try(generic_pipeline.service_connection_ids_authorization, [])
            queue_ids_to_authorize               = try(generic_pipeline.queue_ids_to_authorize, [])
          }
        }
      ]
    ]) : item.key => item.value
  }

  normalized_pipelines = merge(
    local.derived_code_review_pipelines,
    local.derived_deploy_pipelines,
    local.derived_generic_pipelines,
    var.pipelines,
  )

  code_review_pipelines = {
    for name, pipeline in local.normalized_pipelines : name => pipeline
    if pipeline.kind == "code_review"
  }

  deploy_pipelines = {
    for name, pipeline in local.normalized_pipelines : name => pipeline
    if pipeline.kind == "deploy"
  }

  generic_pipelines = {
    for name, pipeline in local.normalized_pipelines : name => pipeline
    if pipeline.kind == "generic"
  }
}

module "code_review" {
  source   = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_code_review?ref=0ae8d9d49f92f690afc66a39f245924a04aa274b"
  for_each = local.code_review_pipelines

  project_id                   = var.project_id
  repository                   = each.value.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.this.id
  path                         = each.value.path
  pipeline_name_prefix         = each.value.pipeline_prefix

  pull_request_trigger_use_yaml = each.value.pull_request_trigger_use_yaml

  variables        = merge(var.base_variables, each.value.variables)
  variables_secret = each.value.variables_secret

  service_connection_ids_authorization = concat(
    [azuredevops_serviceendpoint_github.this.id],
    each.value.service_connection_ids_authorization,
  )
}

module "deploy" {
  source   = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_deploy?ref=0ae8d9d49f92f690afc66a39f245924a04aa274b"
  for_each = local.deploy_pipelines

  project_id                   = var.project_id
  repository                   = each.value.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.this.id
  path                         = each.value.path
  pipeline_name_prefix         = each.value.pipeline_prefix

  variables        = merge(var.base_variables, each.value.variables)
  variables_secret = each.value.variables_secret

  service_connection_ids_authorization = concat(
    [azuredevops_serviceendpoint_github.this.id],
    each.value.service_connection_ids_authorization,
  )
}

module "generic" {
  source   = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_generic?ref=0ae8d9d49f92f690afc66a39f245924a04aa274b"
  for_each = local.generic_pipelines

  project_id                   = var.project_id
  repository                   = each.value.repository
  github_service_connection_id = azuredevops_serviceendpoint_github.this.id
  path                         = each.value.path
  pipeline_name                = each.value.pipeline_name
  pipeline_yml_filename        = each.value.pipeline_yml_filename

  variables = merge(var.base_variables, each.value.variables)

  variables_secret = each.value.variables_secret

  service_connection_ids_authorization = concat(
    [azuredevops_serviceendpoint_github.this.id],
    each.value.service_connection_ids_authorization,
  )
}

resource "azuredevops_pipeline_authorization" "queues" {
  for_each = toset(flatten([
    for pipeline in values(local.normalized_pipelines) : pipeline.queue_ids_to_authorize
  ]))

  project_id  = var.project_id
  resource_id = each.value
  type        = "queue"
}
