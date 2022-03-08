terraform {
  required_version = ">= 1.1.5"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.2.0"
    }
    azurerm = {
      version = ">= 2.98.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}
