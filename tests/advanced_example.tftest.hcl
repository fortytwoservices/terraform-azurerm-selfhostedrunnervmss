mock_provider "azurerm" {}

run "test_advanced_example" {
  command = apply

  module {
    source = "./examples/advanced"
  }

  override_resource {
    target = azurerm_subnet.vmss
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/runners/providers/Microsoft.Network/virtualNetworks/runner-network/subnets/vmss"
    }
  }

  assert {
    condition     = azurerm_resource_group.rg.name == "runners"
    error_message = "The advanced example should create the runners resource group"
  }

  assert {
    condition     = module.vmss.password != ""
    error_message = "The advanced example should expose the VMSS password output"
  }
}