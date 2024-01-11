terraform {
  required_version = ">= 1.3.5"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "<= 0.10.0"
    }
    azurerm = {
      version = "<= 3.85.0"
    }
    time = {
      version = ">= 0.7.0, < 0.8.0"
    }
  }
  backend "azurerm" {}
}

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

data "terraform_remote_state" "app" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.terraform_remote_state_app.resource_group_name
    storage_account_name = var.terraform_remote_state_app.storage_account_name
    container_name       = var.terraform_remote_state_app.container_name
    key                  = var.terraform_remote_state_app.key
  }
}
