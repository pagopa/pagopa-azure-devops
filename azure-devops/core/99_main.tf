terraform {
  required_version = ">= 1.3.5"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.1.1"
    }
    azurerm = {
      version = "~> 3.107.0"
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

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.39.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=e64f39b63d46e8c05470e30eca873f44a0ab7f1b"
}

module "__azdo__" {
  # https://github.com/pagopa/azuredevops-tf-modules/releases/tag/v9.1.0
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git?ref=157a2b963114da99c5e83341e98f81d3c5f47ed8"
}

