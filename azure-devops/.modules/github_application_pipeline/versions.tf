terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
    }
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.dev, azurerm.uat, azurerm.prod]
    }
  }
}
