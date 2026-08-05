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

# Create custom rg
resource "azurerm_resource_group" "rg" {
  location = "westeurope"
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
  source                          = "../.."
  operating_system                = "ubuntu"       # windows or ubuntu
  runner_platform                 = "azure_devops" # azure_devops or github
  resource_group_name             = azurerm_resource_group.rg.name
  use_existing_resource_group     = true
  location                        = azurerm_resource_group.rg.location
  virtual_machine_scale_set_name  = "runners"
  sku                             = "Standard_D2s_v3"
  ssh_public_keys                 = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHqxwgYc8/xszU9E8GmVsoF4jcXeqqEr1dTDEj8ZZoX terraform-example"]
  subnet_id                       = azurerm_subnet.vmss.id
  use_custom_subnet               = true
  vmss_encryption_at_host_enabled = true
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
