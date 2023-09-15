provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "norwayeast"
  name     = "runners"
}

resource "azurerm_virtual_network" "vmss" {
  name                = "runner-network"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "vmss" {
  name                 = "vmss"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vmss.name
  address_prefixes     = azurerm_virtual_network.vmss.address_space
}

module "vmss" {
  source                         = "c:/git/terraform-azurerm-selfhostedrunnervmss" # TODO
  operating_system               = "ubuntu"       # windows or ubuntu
  runner_platform                = "azure_devops" # azure_devops or github
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
