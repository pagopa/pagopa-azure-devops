locals {
  prefix = "pagopa"
  domain = "qa"

  # 🔐 KV per environment.
  # The PAT used by TAS pipelines is stored in the QI domain key vaults
  # (pagopa-{d|u|p}-qi-kv) — one secret per environment.
  # NOTE: the literal "qi" below is intentional: the KVs already exist for the
  # QI domain and host integration secrets shared with TAS. Only the `d/u/p`
  # prefix is parametrized on the environment, exactly like all other contexts.
  dev_qa_key_vault_name  = "${local.prefix}-d-qi-kv"
  uat_qa_key_vault_name  = "${local.prefix}-u-qi-kv"
  prod_qa_key_vault_name = "${local.prefix}-p-qi-kv"

  dev_qa_key_vault_resource_group  = "${local.prefix}-d-qi-sec-rg"
  uat_qa_key_vault_resource_group  = "${local.prefix}-u-qi-sec-rg"
  prod_qa_key_vault_resource_group = "${local.prefix}-p-qi-sec-rg"

  # Name of the secret that holds the GitHub PAT used by the TAS orchestrator.
  # Must exist in each of the three KVs above (dev/uat/prod).
  tas_integration_pat_secret_name = "integration-test-pat"
}

variable "dev_subscription_name" {
  type        = string
  description = "DEV Subscription name"
}

variable "uat_subscription_name" {
  type        = string
  description = "UAT Subscription name"
}

variable "prod_subscription_name" {
  type        = string
  description = "PROD Subscription name"
}

variable "project_name" {
  type        = string
  description = "Azure DevOps project name (e.g. pagoPA)"
}

variable "location" {
  type        = string
  description = "Azure region (kept for symmetry with the other contexts)"
  default     = "westeurope"
}

