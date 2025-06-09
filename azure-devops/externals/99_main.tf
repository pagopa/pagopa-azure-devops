terraform {
  required_version = ">= 1.9.5"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.1"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.101"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 2.50"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.2"
    }
    time = {
      source = "hashicorp/time"
      version = "~> 0.10"
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
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.83.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=087a57940a67444c3b883030c54ceb78562c64ef"
}

module "__azdo__" {
  # https://github.com/pagopa/azuredevops-tf-modules/releases/tag/v9.2.1
  source = "git::https://github.com/pagopa/azuredevops-tf-modules.git?ref=7e23d73d22e7b37352c25a32cc40f6f42b6569ea"
}
