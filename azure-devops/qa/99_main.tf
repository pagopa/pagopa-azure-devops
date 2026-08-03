terraform {
  required_version = ">= 1.9.5"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "<= 1.3.0"
    }
    azurerm = {
      version = "<= 3.107.0"
    }
    time = {
      version = "<= 0.11.0"
    }
  }
  backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  alias           = "dev"
  subscription_id = data.azurerm_subscriptions.dev.subscriptions[0].subscription_id
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  alias           = "uat"
  subscription_id = data.azurerm_subscriptions.uat.subscriptions[0].subscription_id
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  alias           = "prod"
  subscription_id = data.azurerm_subscriptions.prod.subscriptions[0].subscription_id
}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v10.24.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=ee9a7cc6bca4ba9c0ee398adf8cb5105fed8d3d3"
}

module "__azdo__" {
  # https://github.com/pagopa/azuredevops-tf-modules/releases/tag/v9.5.0
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git?ref=0ae8d9d49f92f690afc66a39f245924a04aa274b"
}
