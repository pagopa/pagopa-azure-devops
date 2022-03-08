variable "tlscert-prod-api-prod-product-pagopa-it" {
  default = {
    repository = {
      organization   = "pagopa"
      name           = "le-azure-acme-tiny"
      branch_name    = "master"
      pipelines_path = "."
    }
    pipeline = {
      enable_tls_cert = true
      path            = "TLS-Certificates\\PROD"
      dns_record_name = "api"
      dns_zone_name   = "product.pagopa.it"
      # common variables to all pipelines
      variables = {
        CERT_NAME_EXPIRE_SECONDS = "2592000" #30 days
      }
      # common secret variables to all pipelines
      variables_secret = {
      }
    }
  }
}

locals {
  tlscert-prod-api-prod-product-pagopa-it = {
    tenant_id                           = module.secrets.values["TENANTID"].value
    subscription_name                   = var.prod_subscription_name
    subscription_id                     = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
    dns_zone_resource_group             = local.prod_vnet_rg
    credential_subcription              = var.prod_subscription_name
    credential_key_vault_name           = local.prod_key_vault_name
    credential_key_vault_resource_group = local.prod_key_vault_resource_group
    service_connection_ids_authorization = [
      module.PROD-TLS-CERT-SERVICE-CONN.service_endpoint_id,
    ]
  }
  tlscert-prod-api-prod-product-pagopa-it-variables = {
    KEY_VAULT_SERVICE_CONNECTION = module.PROD-TLS-CERT-SERVICE-CONN.service_endpoint_name,
    KEY_VAULT_NAME               = local.prod_key_vault_name
  }
  tlscert-prod-api-prod-product-pagopa-it-variables_secret = {
  }
}

# change only providers
#tfsec:ignore:general-secrets-no-plaintext-exposure
module "tlscert-prod-api-prod-product-pagopa-it-cert_az" {
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_build_definition_tls_cert?ref=v2.0.5"
  count  = var.tlscert-prod-api-prod-product-pagopa-it.pipeline.enable_tls_cert == true ? 1 : 0

  # change me
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  repository = var.tlscert-prod-api-prod-product-pagopa-it.repository
  name       = "${var.tlscert-prod-api-prod-product-pagopa-it.pipeline.dns_record_name}.${var.tlscert-prod-api-prod-product-pagopa-it.pipeline.dns_zone_name}"
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  #tfsec:ignore:GEN003
  renew_token                  = local.tlscert_renew_token
  path                         = var.tlscert-prod-api-prod-product-pagopa-it.pipeline.path
  github_service_connection_id = azuredevops_serviceendpoint_github.azure-devops-github-ro.id

  dns_record_name         = var.tlscert-prod-api-prod-product-pagopa-it.pipeline.dns_record_name
  dns_zone_name           = var.tlscert-prod-api-prod-product-pagopa-it.pipeline.dns_zone_name
  dns_zone_resource_group = local.tlscert-prod-api-prod-product-pagopa-it.dns_zone_resource_group
  tenant_id               = local.tlscert-prod-api-prod-product-pagopa-it.tenant_id
  subscription_name       = local.tlscert-prod-api-prod-product-pagopa-it.subscription_name
  subscription_id         = local.tlscert-prod-api-prod-product-pagopa-it.subscription_id

  credential_subcription              = local.tlscert-prod-api-prod-product-pagopa-it.credential_subcription
  credential_key_vault_name           = local.tlscert-prod-api-prod-product-pagopa-it.credential_key_vault_name
  credential_key_vault_resource_group = local.tlscert-prod-api-prod-product-pagopa-it.credential_key_vault_resource_group

  variables = merge(
    var.tlscert-prod-api-prod-product-pagopa-it.pipeline.variables,
    local.tlscert-prod-api-prod-product-pagopa-it-variables,
  )

  variables_secret = merge(
    var.tlscert-prod-api-prod-product-pagopa-it.pipeline.variables_secret,
    local.tlscert-prod-api-prod-product-pagopa-it-variables_secret,
  )

  service_connection_ids_authorization = local.tlscert-prod-api-prod-product-pagopa-it.service_connection_ids_authorization

  schedules = {
    days_to_build              = ["Mon"]
    schedule_only_with_changes = false
    start_hours                = 3
    start_minutes              = 0
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = ["master"]
      exclude = []
    }
  }
}
