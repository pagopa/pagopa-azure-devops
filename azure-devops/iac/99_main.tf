terraform {
  required_version = ">= 1.6.5"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "<= 0.11.0"
    }
    azurerm = {
      version = ">= 3.80.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "dev"
  subscription_id = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
}

provider "azurerm" {
  features {}
  alias           = "uat"
  subscription_id = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
}

provider "azurerm" {
  features {}
  alias           = "prod"
  subscription_id = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
}

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.39.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=e64f39b63d46e8c05470e30eca873f44a0ab7f1b"
}

module "__devops_v0__" {
  # https://github.com/pagopa/azuredevops-tf-modules/releases/tag/v9.0.0
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git?ref=7a19400902abf7f58d1af6cb7e34ef83dba5cf68"
}
