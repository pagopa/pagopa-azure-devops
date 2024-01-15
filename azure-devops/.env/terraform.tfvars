location = "westeurope"

dev_subscription_name  = "DEV-PAGOPA"
uat_subscription_name  = "UAT-PAGOPA"
prod_subscription_name = "PROD-PAGOPA"

project_name        = "pagoPA-projects"
project_name_prefix = "pagopa"

pipeline_environments = ["DEV", "UAT", "PROD"]

aks_dev_platform_name  = "pagopa-d-weu-dev-aks"
aks_uat_platform_name  = "pagopa-u-weu-uat-aks"
aks_prod_platform_name = "pagopa-p-weu-prod-aks"

service_connection_dev_azurerm_name  = "PAGOPA-CORE-D-AZDO-AZURERM-SERVICE-CONN"
service_connection_uat_azurerm_name  = "PAGOPA-CORE-U-AZDO-AZURERM-SERVICE-CONN"
service_connection_prod_azurerm_name = "PAGOPA-CORE-P-AZDO-AZURERM-SERVICE-CONN"

service_connection_dev_acr_name = "pagopa-azurecr-dev"
service_connection_uat_acr_name = "pagopa-azurecr-uat"
service_connection_prod_acr_name = "pagopa-azurecr-prod"
