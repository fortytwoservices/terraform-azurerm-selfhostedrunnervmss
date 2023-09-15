provider "azurerm" {
  features {}
}

module "vmss" {
  source                         = "amestofortytwo/selfhostedrunnervmss/azurerm"
  operating_system               = "ubuntu"       # windows or ubuntu
  runner_platform                = "azure_devops" # azure_devops or github
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
