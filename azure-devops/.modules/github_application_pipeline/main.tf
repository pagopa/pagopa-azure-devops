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
  code_review_pipelines = {
    for name, pipeline in var.pipelines : name => pipeline
    if pipeline.kind == "code_review"
  }

  deploy_pipelines = {
    for name, pipeline in var.pipelines : name => pipeline
    if pipeline.kind == "deploy"
  }

  generic_pipelines = {
    for name, pipeline in var.pipelines : name => pipeline
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
    for pipeline in values(var.pipelines) : pipeline.queue_ids_to_authorize
  ]))

  project_id  = var.project_id
  resource_id = each.value
  type        = "queue"
}
