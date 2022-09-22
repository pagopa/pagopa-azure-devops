#
# ⛩ Service connection 2 🔐 KV@DEV 🟢
#
#tfsec:ignore:GEN003
module "DEV-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-d-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
  subscription_name = var.dev_subscription_name

  credential_subcription              = var.dev_subscription_name
  credential_key_vault_name           = local.dev_key_vault_name
  credential_key_vault_resource_group = local.dev_key_vault_resource_group
}

data "azurerm_key_vault" "kv_dev" {
  provider            = azurerm.dev
  name                = local.dev_key_vault_name
  resource_group_name = local.dev_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_dev.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.DEV-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV@UAT 🟨
#
#tfsec:ignore:GEN003
module "UAT-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-u-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
  subscription_name = var.uat_subscription_name

  credential_subcription              = var.uat_subscription_name
  credential_key_vault_name           = local.uat_key_vault_name
  credential_key_vault_resource_group = local.uat_key_vault_resource_group
}

data "azurerm_key_vault" "kv_uat" {
  provider            = azurerm.uat
  name                = local.uat_key_vault_name
  resource_group_name = local.uat_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-TLS-CERT-SERVICE-CONN_kv_uat" {
  provider     = azurerm.uat
  key_vault_id = data.azurerm_key_vault.kv_uat.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.UAT-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV@PROD 🛑
#
#tfsec:ignore:GEN003
module "PROD-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-p-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
  subscription_name = var.prod_subscription_name

  credential_subcription              = var.prod_subscription_name
  credential_key_vault_name           = local.prod_key_vault_name
  credential_key_vault_resource_group = local.prod_key_vault_resource_group
}

data "azurerm_key_vault" "kv_prod" {
  provider            = azurerm.prod
  name                = local.prod_key_vault_name
  resource_group_name = local.prod_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-TLS-CERT-SERVICE-CONN_kv_prod" {
  provider     = azurerm.prod
  key_vault_id = data.azurerm_key_vault.kv_prod.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.PROD-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV-ECOMMERCE@DEV 🟢
#
#tfsec:ignore:GEN003
module "DEV-ECOMMERCE-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-ecommerce-d-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
  subscription_name = var.dev_subscription_name

  credential_subcription              = var.dev_subscription_name
  credential_key_vault_name           = local.dev_ecommerce_key_vault_name
  credential_key_vault_resource_group = local.dev_ecommerce_key_vault_resource_group
}

data "azurerm_key_vault" "kv_ecommerce_dev" {
  provider            = azurerm.dev
  name                = local.dev_ecommerce_key_vault_name
  resource_group_name = local.dev_ecommerce_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-ECOMMERCE-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_ecommerce_dev.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.DEV-ECOMMERCE-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}


#
# ⛩ Service connection 2 🔐 KV-GPS@DEV 🟢
#
#tfsec:ignore:GEN003
module "DEV-GPS-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-gps-d-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
  subscription_name = var.dev_subscription_name

  credential_subcription              = var.dev_subscription_name
  credential_key_vault_name           = local.dev_gps_key_vault_name
  credential_key_vault_resource_group = local.dev_gps_key_vault_resource_group
}

data "azurerm_key_vault" "kv_gps_dev" {
  provider            = azurerm.dev
  name                = local.dev_gps_key_vault_name
  resource_group_name = local.dev_gps_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-GPS-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_gps_dev.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.DEV-GPS-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-SHARED@DEV 🟢
#
#tfsec:ignore:GEN003
module "DEV-SHARED-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-shared-d-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
  subscription_name = var.dev_subscription_name

  credential_subcription              = var.dev_subscription_name
  credential_key_vault_name           = local.dev_shared_key_vault_name
  credential_key_vault_resource_group = local.dev_shared_key_vault_resource_group
}

data "azurerm_key_vault" "kv_shared_dev" {
  provider            = azurerm.dev
  name                = local.dev_shared_key_vault_name
  resource_group_name = local.dev_shared_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-SHARED-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_shared_dev.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.DEV-SHARED-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-AFM@DEV 🟢
#
#tfsec:ignore:GEN003
module "DEV-AFM-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-afm-d-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
  subscription_name = var.dev_subscription_name

  credential_subcription              = var.dev_subscription_name
  credential_key_vault_name           = local.dev_afm_key_vault_name
  credential_key_vault_resource_group = local.dev_afm_key_vault_resource_group
}

data "azurerm_key_vault" "kv_afm_dev" {
  provider            = azurerm.dev
  name                = local.dev_afm_key_vault_name
  resource_group_name = local.dev_afm_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-AFM-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_afm_dev.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.DEV-AFM-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 SELC@DEV 🟢
#
#tfsec:ignore:GEN003
module "DEV-SELC-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.dev
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-selc-d-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
  subscription_name = var.dev_subscription_name

  credential_subcription              = var.dev_subscription_name
  credential_key_vault_name           = local.dev_selc_key_vault_name
  credential_key_vault_resource_group = local.dev_selc_key_vault_resource_group
}

data "azurerm_key_vault" "kv_selc_dev" {
  provider            = azurerm.dev
  name                = local.dev_selc_key_vault_name
  resource_group_name = local.dev_selc_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "DEV-SELC-TLS-CERT-SERVICE-CONN_kv_dev" {
  provider = azurerm.dev

  key_vault_id = data.azurerm_key_vault.kv_selc_dev.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.DEV-SELC-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV-GPS@UAT 🟢
#
#tfsec:ignore:GEN003
module "UAT-GPS-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-gps-u-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
  subscription_name = var.uat_subscription_name

  credential_subcription              = var.uat_subscription_name
  credential_key_vault_name           = local.uat_gps_key_vault_name
  credential_key_vault_resource_group = local.uat_gps_key_vault_resource_group
}

data "azurerm_key_vault" "kv_gps_uat" {
  provider            = azurerm.uat
  name                = local.uat_gps_key_vault_name
  resource_group_name = local.uat_gps_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-GPS-TLS-CERT-SERVICE-CONN_kv_uat" {
  provider = azurerm.uat

  key_vault_id = data.azurerm_key_vault.kv_gps_uat.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.UAT-GPS-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-SHARED@UAT 🟢
#
#tfsec:ignore:GEN003
module "UAT-SHARED-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-shared-u-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
  subscription_name = var.uat_subscription_name

  credential_subcription              = var.uat_subscription_name
  credential_key_vault_name           = local.uat_shared_key_vault_name
  credential_key_vault_resource_group = local.uat_shared_key_vault_resource_group
}

data "azurerm_key_vault" "kv_shared_uat" {
  provider            = azurerm.uat
  name                = local.uat_shared_key_vault_name
  resource_group_name = local.uat_shared_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-SHARED-TLS-CERT-SERVICE-CONN_kv_uat" {
  provider = azurerm.uat

  key_vault_id = data.azurerm_key_vault.kv_shared_uat.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.UAT-SHARED-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-AFM@UAT 🟢
#
#tfsec:ignore:GEN003
module "UAT-AFM-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.uat
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-afm-u-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
  subscription_name = var.uat_subscription_name

  credential_subcription              = var.uat_subscription_name
  credential_key_vault_name           = local.uat_afm_key_vault_name
  credential_key_vault_resource_group = local.uat_afm_key_vault_resource_group
}

data "azurerm_key_vault" "kv_afm_uat" {
  provider            = azurerm.uat
  name                = local.uat_afm_key_vault_name
  resource_group_name = local.uat_afm_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "UAT-AFM-TLS-CERT-SERVICE-CONN_kv_uat" {
  provider = azurerm.uat

  key_vault_id = data.azurerm_key_vault.kv_afm_uat.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.UAT-AFM-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 2 🔐 KV-GPS@PROD 🟢
#
#tfsec:ignore:GEN003
module "PROD-GPS-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-gps-p-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
  subscription_name = var.prod_subscription_name

  credential_subcription              = var.prod_subscription_name
  credential_key_vault_name           = local.prod_gps_key_vault_name
  credential_key_vault_resource_group = local.prod_gps_key_vault_resource_group
}

data "azurerm_key_vault" "kv_gps_prod" {
  provider            = azurerm.prod
  name                = local.prod_gps_key_vault_name
  resource_group_name = local.prod_gps_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-GPS-TLS-CERT-SERVICE-CONN_kv_prod" {
  provider = azurerm.prod

  key_vault_id = data.azurerm_key_vault.kv_gps_prod.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.PROD-GPS-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-SHARED@PROD 🟢
#
#tfsec:ignore:GEN003
module "PROD-SHARED-TLS-CERT-SERVICE-CONN" {
  depends_on = [azuredevops_project.project]
  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
  providers = {
    azurerm = azurerm.prod
  }

  project_id = azuredevops_project.project.id
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  renew_token       = local.tlscert_renew_token
  name              = "${local.prefix}-shared-p-tls-cert-kv-policy"
  tenant_id         = module.secrets.values["TENANTID"].value
  subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
  subscription_name = var.prod_subscription_name

  credential_subcription              = var.prod_subscription_name
  credential_key_vault_name           = local.prod_shared_key_vault_name
  credential_key_vault_resource_group = local.prod_shared_key_vault_resource_group
}

data "azurerm_key_vault" "kv_shared_prod" {
  provider            = azurerm.prod
  name                = local.prod_shared_key_vault_name
  resource_group_name = local.prod_shared_key_vault_resource_group
}

resource "azurerm_key_vault_access_policy" "PROD-SHARED-TLS-CERT-SERVICE-CONN_kv_prod" {
  provider = azurerm.prod

  key_vault_id = data.azurerm_key_vault.kv_shared_prod.id
  tenant_id    = module.secrets.values["TENANTID"].value
  object_id    = module.PROD-SHARED-TLS-CERT-SERVICE-CONN.service_principal_object_id

  certificate_permissions = ["Get", "Import"]
}

#
# ⛩ Service connection 3 🔐 KV-AFM@PROD 🟢
#
#tfsec:ignore:GEN003
#module "PROD-AFM-TLS-CERT-SERVICE-CONN" {
#  depends_on = [azuredevops_project.project]
#  source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.5"
#  providers = {
#    azurerm = azurerm.prod
#  }
#
#  project_id = azuredevops_project.project.id
#  #tfsec:ignore:general-secrets-no-plaintext-exposure
#  renew_token       = local.tlscert_renew_token
#  name              = "${local.prefix}-afm-p-tls-cert-kv-policy"
#  tenant_id         = module.secrets.values["TENANTID"].value
#  subscription_id   = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
#  subscription_name = var.prod_subscription_name
#
#  credential_subcription              = var.prod_subscription_name
#  credential_key_vault_name           = local.prod_afm_key_vault_name
#  credential_key_vault_resource_group = local.prod_afm_key_vault_resource_group
#}
#
#data "azurerm_key_vault" "kv_afm_prod" {
#  provider            = azurerm.prod
#  name                = local.prod_afm_key_vault_name
#  resource_group_name = local.prod_afm_key_vault_resource_group
#}
#
#resource "azurerm_key_vault_access_policy" "PROD-AFM-TLS-CERT-SERVICE-CONN_kv_prod" {
#  provider = azurerm.prod
#
#  key_vault_id = data.azurerm_key_vault.kv_afm_prod.id
#  tenant_id    = module.secrets.values["TENANTID"].value
#  object_id    = module.PROD-AFM-TLS-CERT-SERVICE-CONN.service_principal_object_id
#
#  certificate_permissions = ["Get", "Import"]
#}
