mock_provider "azurerm" {}

run "test_basic_example" {
  command = apply

  module {
    source = "./examples/basic"
  }

  override_resource {
    target = module.vmss.azurerm_public_ip.load_balancer_ng["vmss"]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/runners/providers/Microsoft.Network/publicIPAddresses/runners"
    }
  }

  override_resource {
    target = module.vmss.azurerm_public_ip.load_balancer_pip[0]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/runners/providers/Microsoft.Network/publicIPAddresses/runners-lb"
    }
  }

  override_resource {
    target = module.vmss.azurerm_lb.load_balancer[0]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/runners/providers/Microsoft.Network/loadBalancers/runners"
    }
  }

  override_resource {
    target = module.vmss.azurerm_subnet.vmss[0]
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/runners/providers/Microsoft.Network/virtualNetworks/runners-net/subnets/vmss"
    }
  }

  assert {
    condition     = module.vmss.password != ""
    error_message = "The basic example should expose the VMSS password output"
  }
}
