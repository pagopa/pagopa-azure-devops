locals {

  certificates = {
    # qa.itn.internal.dev.platform.pagopa.it
    qa-itn-internal-dev-platform-pagopa-it : {
      env              = "dev"
      dns_record_name  = "qa.itn.internal"
      dns_zone_name    = "dev.platform.pagopa.it"
      dns_zone_rg      = local.dev_internal_dns_zone
      variables        = {}
      variables_secret = {}
    }
    # qa-superset.itn.internal.dev.platform.pagopa.it
    qa-superset-itn-internal-dev-platform-pagopa-it : {
      env              = "dev"
      dns_record_name  = "qa-superset.itn.internal"
      dns_zone_name    = "dev.platform.pagopa.it"
      dns_zone_rg      = local.dev_internal_dns_zone
      variables        = {}
      variables_secret = {}
    }

    # qa.itn.internal.uat.platform.pagopa.it
    qa-itn-internal-uat-platform-pagopa-it : {
      env              = "uat"
      dns_record_name  = "qa.itn.internal"
      dns_zone_name    = "uat.platform.pagopa.it"
      dns_zone_rg      = local.uat_internal_dns_zone
      variables        = {}
      variables_secret = {}
    }
    # qa-superset.itn.internal.uat.platform.pagopa.it
    qa-superset-itn-internal-uat-platform-pagopa-it : {
      env              = "uat"
      dns_record_name  = "qa-superset.itn.internal"
      dns_zone_name    = "uat.platform.pagopa.it"
      dns_zone_rg      = local.uat_internal_dns_zone
      variables        = {}
      variables_secret = {}
    }

    # qa.itn.internal.platform.pagopa.it
    qa-itn-internal-platform-pagopa-it : {
      env              = "prod"
      dns_record_name  = "qa.itn.internal"
      dns_zone_name    = "platform.pagopa.it"
      dns_zone_rg      = local.prod_internal_dns_zone
      variables        = {}
      variables_secret = {}
    }
    # qa-superset.itn.internal.platform.pagopa.it
    qa-superset-itn-internal-platform-pagopa-it : {
      env              = "prod"
      dns_record_name  = "qa-superset.itn.internal"
      dns_zone_name    = "platform.pagopa.it"
      dns_zone_rg      = local.prod_internal_dns_zone
      variables        = {}
      variables_secret = {}
    }
  }

}

# change only providers
#tfsec:ignore:general-secrets-no-plaintext-exposure
module "federated_cert_pipeline_dev" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated"

  for_each = { for k, v in local.certificates : k => v if v.env == "dev" }

  providers = {
    azurerm = azurerm.dev
  }

  location                             = var.location
  managed_identity_resource_group_name = local.dev_identity_rg_name

  project_id                   = data.azuredevops_project.project.id
  repository                   = local.tlscert_repository
  path                         = "TLS-Certificates\\${upper(each.value.env)}"
  github_service_connection_id = azuredevops_serviceendpoint_github.github_qa.id

  dns_record_name         = each.value.dns_record_name
  dns_zone_name           = each.value.dns_zone_name
  dns_zone_resource_group = each.value.dns_zone_rg
  tenant_id               = data.azurerm_client_config.current.tenant_id
  subscription_name       = local.env_configurations[each.value.env].subscription_name
  subscription_id         = local.env_configurations[each.value.env].subscription_id

  credential_key_vault_name           = local.env_configurations[each.value.env].credential_key_vault_name
  credential_key_vault_resource_group = local.env_configurations[each.value.env].credential_key_vault_resource_group

  variables = merge(
    local.env_configurations[each.value.env].variables,
    each.value.variables
  )

  variables_secret = merge(
    local.env_configurations[each.value.env].variables_secret,
    each.value.variables_secret
  )

  service_connection_ids_authorization = [local.env_configurations[each.value.env].service_endpoint_id]

  schedules = {
    days_to_build              = try(each.value.schedules.days_to_build, ["Wed", "Fri"])
    schedule_only_with_changes = false
    start_hours                = try(each.value.schedules.start_hours, 4)
    start_minutes              = try(each.value.schedules.start_minutes, 30)
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = [local.tlscert_repository.branch_name]
      exclude = []
    }
  }

  depends_on = [
    module.dev_tls_cert_service_connection
  ]
}

# change only providers
#tfsec:ignore:general-secrets-no-plaintext-exposure
module "federated_cert_pipeline_uat" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated"

  for_each = { for k, v in local.certificates : k => v if v.env == "uat" }

  providers = {
    azurerm = azurerm.uat
  }

  location                             = var.location
  managed_identity_resource_group_name = local.uat_identity_rg_name

  project_id                   = data.azuredevops_project.project.id
  repository                   = local.tlscert_repository
  path                         = "TLS-Certificates\\${upper(each.value.env)}"
  github_service_connection_id = azuredevops_serviceendpoint_github.github_qa.id

  dns_record_name         = each.value.dns_record_name
  dns_zone_name           = each.value.dns_zone_name
  dns_zone_resource_group = each.value.dns_zone_rg
  tenant_id               = data.azurerm_client_config.current.tenant_id
  subscription_name       = local.env_configurations[each.value.env].subscription_name
  subscription_id         = local.env_configurations[each.value.env].subscription_id

  credential_key_vault_name           = local.env_configurations[each.value.env].credential_key_vault_name
  credential_key_vault_resource_group = local.env_configurations[each.value.env].credential_key_vault_resource_group

  variables = merge(
    local.env_configurations[each.value.env].variables,
    each.value.variables
  )

  variables_secret = merge(
    local.env_configurations[each.value.env].variables_secret,
    each.value.variables_secret
  )

  service_connection_ids_authorization = [local.env_configurations[each.value.env].service_endpoint_id]

  schedules = {
    days_to_build              = try(each.value.schedules.days_to_build, ["Wed", "Fri"])
    schedule_only_with_changes = false
    start_hours                = try(each.value.schedules.start_hours, 4)
    start_minutes              = try(each.value.schedules.start_minutes, 30)
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = [local.tlscert_repository.branch_name]
      exclude = []
    }
  }

  depends_on = [
    module.uat_tls_cert_service_connection
  ]
}


# change only providers
#tfsec:ignore:general-secrets-no-plaintext-exposure
module "federated_cert_pipeline_prod" {
  source = "./.terraform/modules/__azdo__/azuredevops_build_definition_tls_cert_federated"

  for_each = { for k, v in local.certificates : k => v if v.env == "prod" }

  providers = {
    azurerm = azurerm.prod
  }

  location                             = var.location
  managed_identity_resource_group_name = local.prod_identity_rg_name

  project_id                   = data.azuredevops_project.project.id
  repository                   = local.tlscert_repository
  path                         = "TLS-Certificates\\${upper(each.value.env)}"
  github_service_connection_id = azuredevops_serviceendpoint_github.github_qa.id

  dns_record_name         = each.value.dns_record_name
  dns_zone_name           = each.value.dns_zone_name
  dns_zone_resource_group = each.value.dns_zone_rg
  tenant_id               = data.azurerm_client_config.current.tenant_id
  subscription_name       = local.env_configurations[each.value.env].subscription_name
  subscription_id         = local.env_configurations[each.value.env].subscription_id

  credential_key_vault_name           = local.env_configurations[each.value.env].credential_key_vault_name
  credential_key_vault_resource_group = local.env_configurations[each.value.env].credential_key_vault_resource_group

  variables = merge(
    local.env_configurations[each.value.env].variables,
    each.value.variables
  )

  variables_secret = merge(
    local.env_configurations[each.value.env].variables_secret,
    each.value.variables_secret
  )

  service_connection_ids_authorization = [local.env_configurations[each.value.env].service_endpoint_id]

  schedules = {
    days_to_build              = try(each.value.schedules.days_to_build, ["Wed", "Fri"])
    schedule_only_with_changes = false
    start_hours                = try(each.value.schedules.start_hours, 4)
    start_minutes              = try(each.value.schedules.start_minutes, 30)
    time_zone                  = "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
    branch_filter = {
      include = [local.tlscert_repository.branch_name]
      exclude = []
    }
  }

  depends_on = [
    module.prod_tls_cert_service_connection
  ]
}
