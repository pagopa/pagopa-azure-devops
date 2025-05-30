terraform {
  required_version = ">= 1.3.5"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.9"
    }
    azurerm = {
      version = "~> 3.117"
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
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tagv/8.97.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=33777a27f8f917a96220f5cf8fb3c3eee8e594b0"
}

module "__azdo__" {
  # https://github.com/pagopa/azuredevops-tf-modules/releases/tag/v9.4.1
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git?ref=feat/add-alarm-cert-diff"
}
