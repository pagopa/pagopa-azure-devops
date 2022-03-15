# Github service connection (read-only)
# resource "azuredevops_serviceendpoint_github" "io-azure-devops-github-ro" {
#   depends_on = [azuredevops_project.project]

#   project_id            = azuredevops_project.project.id
#   service_endpoint_name = "io-azure-devops-github-ro"
#   auth_personal {
#     personal_access_token = module.secrets.values["io-azure-devops-github-ro-TOKEN"].value
#   }
#   lifecycle {
#     ignore_changes = [description, authorization]
#   }
# }

# # Github service connection (pull request)
# resource "azuredevops_serviceendpoint_github" "io-azure-devops-github-pr" {
#   depends_on = [azuredevops_project.project]

#   project_id            = azuredevops_project.project.id
#   service_endpoint_name = "io-azure-devops-github-pr"
#   auth_personal {
#     personal_access_token = module.secrets.values["io-azure-devops-github-pr-TOKEN"].value
#   }
#   lifecycle {
#     ignore_changes = [description, authorization]
#   }
# }

# # Github service connection (read-write)
# resource "azuredevops_serviceendpoint_github" "io-azure-devops-github-rw" {
#   depends_on = [azuredevops_project.project]

#   project_id            = azuredevops_project.project.id
#   service_endpoint_name = "io-azure-devops-github-rw"
#   auth_personal {
#     personal_access_token = module.secrets.values["io-azure-devops-github-rw-TOKEN"].value
#   }
#   lifecycle {
#     ignore_changes = [description, authorization]
#   }
# }

# TODO azure devops terraform provider does not support SonarCloud service endpoint
# locals {
#   azuredevops_serviceendpoint_sonarcloud_id = "f922a0a4-fb66-4cf9-bf97-d6898491a5fd"
# }

# # DEV service connection
# resource "azuredevops_serviceendpoint_azurerm" "DEV-PAGOPA" {
#   depends_on = [azuredevops_project.project]

#   project_id                = azuredevops_project.project.id
#   service_endpoint_name     = "DEV-PAGOPA-SERVICE-CONN"
#   description               = "DEV-PAGOPA Service connection"
#   azurerm_subscription_name = "DEV-PAGOPA"
#   azurerm_spn_tenantid      = module.secrets.values["PAGOPAIT-TENANTID"].value
#   azurerm_subscription_id   = module.secrets.values["PAGOPAIT-DEV-PAGOPA-SUBSCRIPTION-ID"].value
# }

# # UAT service connection
# resource "azuredevops_serviceendpoint_azurerm" "UAT-PAGOPA" {
#   depends_on = [azuredevops_project.project]

#   project_id                = azuredevops_project.project.id
#   service_endpoint_name     = "UAT-PAGOPA-SERVICE-CONN"
#   description               = "UAT-PAGOPA Service connection"
#   azurerm_subscription_name = "UAT-PAGOPA"
#   azurerm_spn_tenantid      = module.secrets.values["PAGOPAIT-TENANTID"].value
#   azurerm_subscription_id   = module.secrets.values["PAGOPAIT-UAT-PAGOPA-SUBSCRIPTION-ID"].value
# }

# # PROD service connection
# resource "azuredevops_serviceendpoint_azurerm" "PROD-PAGOPA" {
#   depends_on = [azuredevops_project.project]

#   project_id                = azuredevops_project.project.id
#   service_endpoint_name     = "PROD-PAGOPA-SERVICE-CONN"
#   description               = "PROD-PAGOPA Service connection"
#   azurerm_subscription_name = "PROD-PAGOPA"
#   azurerm_spn_tenantid      = module.secrets.values["PAGOPAIT-TENANTID"].value
#   azurerm_subscription_id   = module.secrets.values["PAGOPAIT-PROD-PAGOPA-SUBSCRIPTION-ID"].value
# }

# module "DEV-PAGOPA-TLS-CERT-SERVICE-CONN" {
#   depends_on = [azuredevops_project.project]
#   source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.4"

#   project_id = azuredevops_project.project.id
#   #tfsec:ignore:GEN003
#   renew_token       = local.tlscert_renew_token
#   name              = "pagopa-d-tls-cert"
#   tenant_id         = module.secrets.values["PAGOPAIT-TENANTID"].value
#   subscription_id   = module.secrets.values["PAGOPAIT-DEV-PAGOPA-SUBSCRIPTION-ID"].value
#   subscription_name = "DEV-PAGOPA"

#   credential_subcription              = local.key_vault_subscription
#   credential_key_vault_name           = local.key_vault_name
#   credential_key_vault_resource_group = local.key_vault_resource_group
# }

# data "azurerm_key_vault" "kv_dev" {
#   provider            = azurerm.dev-pagopa
#   name                = format("%s-d-kv", local.prefix)
#   resource_group_name = format("%s-d-sec-rg", local.prefix)
# }

# resource "azurerm_key_vault_access_policy" "DEV-PAGOPA-TLS-CERT-SERVICE-CONN_kv_dev" {
#   provider     = azurerm.dev-pagopa
#   key_vault_id = data.azurerm_key_vault.kv_dev.id
#   tenant_id    = module.secrets.values["PAGOPAIT-TENANTID"].value
#   object_id    = module.DEV-PAGOPA-TLS-CERT-SERVICE-CONN.service_principal_object_id

#   certificate_permissions = ["Get", "Import"]
# }

# module "UAT-PAGOPA-TLS-CERT-SERVICE-CONN" {
#   depends_on = [azuredevops_project.project]
#   source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.4"

#   project_id = azuredevops_project.project.id
#   #tfsec:ignore:GEN003
#   renew_token       = local.tlscert_renew_token
#   name              = "pagopa-u-tls-cert"
#   tenant_id         = module.secrets.values["PAGOPAIT-TENANTID"].value
#   subscription_id   = module.secrets.values["PAGOPAIT-UAT-PAGOPA-SUBSCRIPTION-ID"].value
#   subscription_name = "UAT-PAGOPA"

#   credential_subcription              = local.key_vault_subscription
#   credential_key_vault_name           = local.key_vault_name
#   credential_key_vault_resource_group = local.key_vault_resource_group
# }

# data "azurerm_key_vault" "kv_uat" {
#   provider            = azurerm.uat-pagopa
#   name                = format("%s-u-kv", local.prefix)
#   resource_group_name = format("%s-u-sec-rg", local.prefix)
# }

# resource "azurerm_key_vault_access_policy" "UAT-PAGOPA-TLS-CERT-SERVICE-CONN_kv_uat" {
#   provider     = azurerm.uat-pagopa
#   key_vault_id = data.azurerm_key_vault.kv_uat.id
#   tenant_id    = module.secrets.values["PAGOPAIT-TENANTID"].value
#   object_id    = module.UAT-PAGOPA-TLS-CERT-SERVICE-CONN.service_principal_object_id

#   certificate_permissions = ["Get", "Import"]
# }

# module "PROD-PAGOPA-TLS-CERT-SERVICE-CONN" {
#   depends_on = [azuredevops_project.project]
#   source     = "git::https://github.com/pagopa/azuredevops-tf-modules.git//azuredevops_serviceendpoint_azurerm_limited?ref=v2.0.4"

#   project_id = azuredevops_project.project.id
#   #tfsec:ignore:GEN003
#   renew_token       = local.tlscert_renew_token
#   name              = "pagopa-p-tls-cert"
#   tenant_id         = module.secrets.values["PAGOPAIT-TENANTID"].value
#   subscription_id   = module.secrets.values["PAGOPAIT-PROD-PAGOPA-SUBSCRIPTION-ID"].value
#   subscription_name = "PROD-PAGOPA"

#   credential_subcription              = local.key_vault_subscription
#   credential_key_vault_name           = local.key_vault_name
#   credential_key_vault_resource_group = local.key_vault_resource_group
# }

# data "azurerm_key_vault" "kv_prod" {
#   provider            = azurerm.prod-pagopa
#   name                = format("%s-p-kv", local.prefix)
#   resource_group_name = format("%s-p-sec-rg", local.prefix)
# }

# resource "azurerm_key_vault_access_policy" "PROD-PAGOPA-TLS-CERT-SERVICE-CONN_kv_prod" {
#   provider     = azurerm.prod-pagopa
#   key_vault_id = data.azurerm_key_vault.kv_prod.id
#   tenant_id    = module.secrets.values["PAGOPAIT-TENANTID"].value
#   object_id    = module.PROD-PAGOPA-TLS-CERT-SERVICE-CONN.service_principal_object_id

#   certificate_permissions = ["Get", "Import"]
# }

# # DEV service connection for azure container registry 
# resource "azuredevops_serviceendpoint_azurecr" "pagopa-azurecr-dev" {
#   depends_on = [azuredevops_project.project]

#   project_id                = azuredevops_project.project.id
#   service_endpoint_name     = "pagopa-azurecr-dev"
#   resource_group            = "pagopa-d-aks-rg"
#   azurecr_name              = "pagopadacr"
#   azurecr_subscription_name = "DEV-PAGOPA"
#   azurecr_spn_tenantid      = module.secrets.values["PAGOPAIT-TENANTID"].value
#   azurecr_subscription_id   = module.secrets.values["PAGOPAIT-DEV-PAGOPA-SUBSCRIPTION-ID"].value
# }

# # UAT service connection for azure container registry 
# resource "azuredevops_serviceendpoint_azurecr" "pagopa-azurecr-uat" {
#   depends_on = [azuredevops_project.project]

#   project_id                = azuredevops_project.project.id
#   service_endpoint_name     = "pagopa-azurecr-uat"
#   resource_group            = "pagopa-u-aks-rg"
#   azurecr_name              = "pagopauacr"
#   azurecr_subscription_name = "UAT-PAGOPA"
#   azurecr_spn_tenantid      = module.secrets.values["PAGOPAIT-TENANTID"].value
#   azurecr_subscription_id   = module.secrets.values["PAGOPAIT-UAT-PAGOPA-SUBSCRIPTION-ID"].value
# }

# # PROD service connection for azure container registry 
# resource "azuredevops_serviceendpoint_azurecr" "pagopa-azurecr-prod" {
#   depends_on = [azuredevops_project.project]

#   project_id                = azuredevops_project.project.id
#   service_endpoint_name     = "pagopa-azurecr-prod"
#   resource_group            = "pagopa-p-aks-rg"
#   azurecr_name              = "pagopapacr"
#   azurecr_subscription_name = "PROD-PAGOPA"
#   azurecr_spn_tenantid      = module.secrets.values["PAGOPAIT-TENANTID"].value
#   azurecr_subscription_id   = module.secrets.values["PAGOPAIT-PROD-PAGOPA-SUBSCRIPTION-ID"].value
# }


