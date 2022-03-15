# terraform {
#   required_version = ">= 0.14.5"
#   backend "azurerm" {
#     resource_group_name  = "io-infra-rg"
#     storage_account_name = "ioinfrastterraform"
#     container_name       = "azuredevopsstate"
#     key                  = "pagopa-projects.terraform.tfstate"
#   }
#   required_providers {
#     azuredevops = {
#       source  = "microsoft/azuredevops"
#       version = "= 0.1.8"
#     }
#     azurerm = {
#       version = "~> 2.52.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }

# provider "azurerm" {
#   features {}
#   alias           = "prod-pagopa"
#   subscription_id = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
# }

# provider "azurerm" {
#   features {}
#   alias           = "uat-pagopa"
#   subscription_id = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
# }


# provider "azurerm" {
#   features {}
#   alias           = "dev-pagopa"
#   subscription_id = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
# }
