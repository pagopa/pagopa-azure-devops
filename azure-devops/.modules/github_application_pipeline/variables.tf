variable "project_id" {
  type        = string
  description = "Azure DevOps project ID"
}

variable "github_service_connection_name" {
  type        = string
  description = "Azure DevOps GitHub service connection name"
}

variable "github_token_key_vault_name" {
  type        = string
  description = "Key Vault name containing the GitHub PAT"
}

variable "github_token_key_vault_resource_group" {
  type        = string
  description = "Key Vault resource group containing the GitHub PAT"
}

variable "github_token_secret_name" {
  type        = string
  description = "Secret name containing the GitHub PAT"
}

variable "base_variables" {
  type        = map(string)
  description = "Variables shared by the pipelines"
  default     = {}
}

variable "applications" {
  description = "Application-centric pipeline definitions with feature flags"

  type = map(object({
    repository = object({
      organization    = string
      name            = string
      branch_name     = string
      pipelines_path  = string
      yml_prefix_name = any
    })
    path            = string
    pipeline_prefix = string

    enable_code_review = optional(bool, true)
    enable_deploy      = optional(bool, true)

    code_review = optional(object({
      pull_request_trigger_use_yaml        = optional(bool, true)
      variables                            = optional(map(string), {})
      variables_secret                     = optional(map(string), {})
      service_connection_ids_authorization = optional(list(string), [])
      queue_ids_to_authorize               = optional(list(string), [])
    }), {})

    deploy = optional(object({
      variables                            = optional(map(string), {})
      variables_secret                     = optional(map(string), {})
      service_connection_ids_authorization = optional(list(string), [])
      queue_ids_to_authorize               = optional(list(string), [])
    }), {})

    generic = optional(map(object({
      pipeline_name                        = string
      pipeline_yml_filename                = string
      variables                            = optional(map(string), {})
      variables_secret                     = optional(map(string), {})
      service_connection_ids_authorization = optional(list(string), [])
      queue_ids_to_authorize               = optional(list(string), [])
    })), {})
  }))

  default = {}
}

variable "pipelines" {
  description = "Low-level pipeline definitions grouped by kind (advanced/legacy path)"

  type = map(object({
    kind = string
    repository = object({
      organization    = string
      name            = string
      branch_name     = string
      pipelines_path  = string
      yml_prefix_name = any
    })
    path                                 = string
    pipeline_prefix                      = optional(string)
    pipeline_name                        = optional(string)
    pipeline_yml_filename                = optional(string)
    pull_request_trigger_use_yaml        = optional(bool, true)
    variables                            = optional(map(string), {})
    variables_secret                     = optional(map(string), {})
    service_connection_ids_authorization = optional(list(string), [])
    queue_ids_to_authorize               = optional(list(string), [])
  }))

  default = {}
}
