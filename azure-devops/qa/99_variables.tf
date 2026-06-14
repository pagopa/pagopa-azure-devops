locals {
  prefix = "pagopa"
  domain = "qa"
  location_short = "itn"

  # 🔐 KV per environment.
  dev_qa_key_vault_name  = "${local.prefix}-${local.location_short}-d-qa-kv"
  uat_qa_key_vault_name  = "${local.prefix}-${local.location_short}-u-qa-kv"
  prod_qa_key_vault_name = "${local.prefix}-${local.location_short}-p-qa-kv"

  dev_qa_key_vault_resource_group  = "${local.prefix}-${local.location_short}-d-qa-sec-rg"
  uat_qa_key_vault_resource_group  = "${local.prefix}-${local.location_short}-u-qa-sec-rg"
  prod_qa_key_vault_resource_group = "${local.prefix}-${local.location_short}-p-qa-sec-rg"

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
