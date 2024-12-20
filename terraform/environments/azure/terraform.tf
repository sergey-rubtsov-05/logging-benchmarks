terraform {
  required_version = ">= 1.8.1"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>2.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.12"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
