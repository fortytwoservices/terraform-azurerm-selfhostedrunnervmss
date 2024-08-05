terraform {
  required_version = ">=1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "vmss" {
  source               = "amestofortytwo/selfhostedrunnervmss/azurerm"
  version              = "1.6.0"
  operating_system     = "ubuntu"       # windows or ubuntu
  runner_platform      = "azure_devops" # azure_devops or github
  deploy_load_balancer = true
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
