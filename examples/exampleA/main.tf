provider "azurerm" {
  features {}
}

module "vmss" {
  source                         = "c:/git/terraform-azurerm-selfhostedrunnervmss" # TODO
  operating_system               = "ubuntu"       # windows or ubuntu
  runner_platform                = "azure_devops" # azure_devops or github
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
