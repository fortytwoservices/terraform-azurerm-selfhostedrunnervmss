terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.114.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = ">= 2.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.2"
    }
  }
}