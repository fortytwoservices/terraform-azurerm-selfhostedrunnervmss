provider "azurerm" {
  features {}
}

# Create custom rg
resource "azurerm_resource_group" "rg" {
  location = "norwayeast"
  name     = "runners"
}

# Create custom vnet
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
  source                         = "amestofortytwo/selfhostedrunnervmss/azurerm"
  operating_system               = "ubuntu"       # windows or ubuntu
  runner_platform                = "azure_devops" # azure_devops or github
  resource_group_name            = azurerm_resource_group.rg.name
  use_existing_resource_group    = true
  location                       = azurerm_resource_group.rg.location
  virtual_machine_scale_set_name = "runners"
  sku                            = "Standard_D2s_v3"
  ssh_public_keys                = ["ssh-rsa AAAAB3NzaC1yc2EAAAADA....QFv2PJ0= marius@42device"]
  subnet_id                      = azurerm_subnet.vmss.id
  use_custom_subnet              = true
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
