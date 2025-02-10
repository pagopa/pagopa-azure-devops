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
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
  alias           = "dev"
  subscription_id = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
  alias           = "uat"
  subscription_id = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
  alias           = "prod"
  subscription_id = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
}
