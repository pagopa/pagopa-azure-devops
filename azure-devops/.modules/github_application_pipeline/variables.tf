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

variable "pipelines" {
  description = "Pipeline definitions grouped by kind"

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
}
