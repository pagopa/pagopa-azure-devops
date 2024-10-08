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

service_connection_dev_azurerm_name  = "DEV-PAGOPA-SERVICE-CONN"
service_connection_uat_azurerm_name  = "UAT-PAGOPA-SERVICE-CONN"
service_connection_prod_azurerm_name = "PROD-PAGOPA-SERVICE-CONN"

service_connection_dev_acr_name  = "pagopa-azurecr-dev"
service_connection_uat_acr_name  = "pagopa-azurecr-uat"
service_connection_prod_acr_name = "pagopa-azurecr-prod"

acr_weu_service_connection_workload_identity_dev  = "docker-registry-weu-dev-workload-identity"
acr_weu_service_connection_workload_identity_uat  = "docker-registry-weu-uat-workload-identity"
acr_weu_service_connection_workload_identity_prod = "docker-registry-weu-prod-workload-identity"

acr_ita_service_connection_workload_identity_dev  = "docker-registry-ita-dev-workload-identity"
acr_ita_service_connection_workload_identity_uat  = "docker-registry-ita-uat-workload-identity"
acr_ita_service_connection_workload_identity_prod = "docker-registry-ita-prod-workload-identity"
