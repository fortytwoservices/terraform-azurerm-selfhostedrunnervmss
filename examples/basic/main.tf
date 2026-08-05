terraform {
  required_version = ">=1.13.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=5.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "vmss" {
  source               = "../.."
  operating_system     = "ubuntu"       # windows or ubuntu
  runner_platform      = "azure_devops" # azure_devops or github
  deploy_load_balancer = true
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
