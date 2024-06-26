terraform {
  required_version = ">= 1.3.5"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "<= 1.1.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.107.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "<= 0.11.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "<= 3.2.1"
    }
  }
  backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  alias           = "dev"
  subscription_id = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  alias           = "uat"
  subscription_id = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  alias           = "prod"
  subscription_id = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
}
