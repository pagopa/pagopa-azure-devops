terraform {
  required_version = ">= 1.3.5"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 0.10.0"
    }
    azurerm = {
      version = "<= 3.85.0"
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
  subscription_id = module.secrets.values["DEV-SUBSCRIPTION-ID"].value
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  alias           = "uat"
  subscription_id = module.secrets.values["UAT-SUBSCRIPTION-ID"].value
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  alias           = "prod"
  subscription_id = module.secrets.values["PROD-SUBSCRIPTION-ID"].value
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
