variable "tlscert-uat-checkout-pagopa-it" {
  default = {
    repository = {
      organization   = "pagopa"
      name           = "le-azure-acme-tiny"
      branch_name    = "master"
      pipelines_path = "."
    }
    pipeline = {
      enable_tls_cert         = true
      path                    = "TLS-Certificates\\UAT"
      dns_record_name         = ""
      dns_zone_name           = "uat.checkout.pagopa.it"
      dns_zone_resource_group = "pagopa-u-vnet-rg"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
        KEY_VAULT_NAME           = "pagopa-u-kv"
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-uat-checkout-pagopa-it = {
    tenant_id         = module.secrets.values["PAGOPAIT-TENANTID"].value
    subscription_name = "UAT-PAGOPA"
    subscription_id   = module.secrets.values["PAGOPAIT-UAT-PAGOPA-SUBSCRIPTION-ID"].value
  }
  tlscert-uat-checkout-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.UAT-TLS-CERT-SERVICE-CONN.service_endpoint_name
  }
  tlscert-uat-checkout-pagopa-it-variables_secret = {
  }
}

module "tlscert-uat-checkout-pagopa-it-cert_az" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert?ref=v2.0.4"
  count  = var.tlscert-uat-checkout-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  project_id = azuredevops_project.project.id
  repository = var.tlscert-uat-checkout-pagopa-it.repository
  name       = "${var.tlscert-uat-checkout-pagopa-it.pipeline.dns_record_name}.${var.tlscert-uat-checkout-pagopa-it.pipeline.dns_zone_name}"
  #tfsec:ignore:GEN003
  renew_token                  = local.tlscert_renew_token
  path                         = var.tlscert-uat-checkout-pagopa-it.pipeline.path
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-ro.id

  dns_record_name         = var.tlscert-uat-checkout-pagopa-it.pipeline.dns_record_name
  dns_zone_name           = var.tlscert-uat-checkout-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group = var.tlscert-uat-checkout-pagopa-it.pipeline.dns_zone_resource_group
  tenant_id               = local.tlscert-uat-checkout-pagopa-it.tenant_id
  subscription_name       = local.tlscert-uat-checkout-pagopa-it.subscription_name
  subscription_id         = local.tlscert-uat-checkout-pagopa-it.subscription_id

  credential_subcription              = local.key_vault_subscription
  credential_key_vault_name           = local.key_vault_name
  credential_key_vault_resource_group = local.key_vault_resource_group

  variables = merge(
    var.tlscert-uat-checkout-pagopa-it.pipeline.variables,
    local.tlscert-uat-checkout-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-uat-checkout-pagopa-it.pipeline.variables_secret,
    local.tlscert-uat-checkout-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = [
    module.UAT-TLS-CERT-SERVICE-CONN.service_endpoint_id,
  ]
}
