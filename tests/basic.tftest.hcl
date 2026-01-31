variables {
  resource_group_name            = "rg-test-vmss"
  location                       = "westeurope"
  virtual_machine_scale_set_name = "vmss-test"
  operating_system               = "ubuntu"
  runner_platform                = "github"
}

mock_provider "azapi" {}
mock_provider "azurerm" {}

run "verify_linux_plan" {
  command = plan

  variables {
    operating_system = "ubuntu"
  }

  assert {
    condition     = azapi_resource.vmss_linux[0].name == "vmss-test"
    error_message = "VMSS name did not match expected"
  }

  assert {
    condition     = azapi_resource.vmss_linux[0].body.properties.virtualMachineProfile.osProfile.computerNamePrefix == "vmss-test"
    error_message = "Computer name prefix did not match expected"
  }
}

run "verify_windows_plan" {
  command = plan

  variables {
    operating_system = "windows"
  }

  assert {
    condition     = azapi_resource.vmss_windows[0].name == "vmss-test"
    error_message = "VMSS name did not match expected"
  }
}

run "verify_validations" {
  command = plan

  variables {
    operating_system = "macos" # Invalid
  }

  expect_failures = [
    var.operating_system
  ]
}
