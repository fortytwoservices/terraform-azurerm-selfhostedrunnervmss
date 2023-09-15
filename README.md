<!-- BEGIN_TF_DOCS -->
# Self Hosted Runners Virtual Machine Scale Set

This module deploys a virtual machine scale set for self hosted runners for Azure DevOps and GitHub.

```hcl
provider "azurerm" {
  features {}
}

module "vmss" {
  source                         = "amestofortytwo/selfhostedrunnervmss/azurerm"
  operating_system               = "ubuntu"       # windows or ubuntu
  runner_platform                = "azure_devops" # azure_devops or github
}
```

After deploying the virtual machine scale set, you need to configure Azure DevOps or GitHub:

- [Configure Azure DevOps Agent Pool](https://docs.byfortytwo.com/Self%20Hosted%20Runners/azuredevops-vmss-step2/)
- [Configure GitHub](https://docs.byfortytwo.com/Self%20Hosted%20Runners/github-vmss-step2/)

## Requirements

No requirements.

## Examples

### Example A

```hcl
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
```

### Example B

```hcl
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
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The Azure region to create the scale set in | `string` | `"westeurope"` | no |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The OS of the runners | `string` | `"ubuntu"` | no |
| <a name="input_password"></a> [password](#input\_password) | Password of the local user acocunt | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name to create | `string` | `"self-hosted-runners"` | no |
| <a name="input_runner_platform"></a> [runner\_platform](#input\_runner\_platform) | Whether it is github or azure\_devops used for runners | `string` | `"azure_devops"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku to create virtual machines with | `string` | `"Standard_D2s_v3"` | no |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | n/a | `list(string)` | `[]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | When provided, this subnet will be used for the scale set, rather than creating a new virtual network and subnet | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | `{}` | no |
| <a name="input_use_custom_subnet"></a> [use\_custom\_subnet](#input\_use\_custom\_subnet) | Set to true if subnet\_id is provided in order to actually use it (works around a TF issue) | `bool` | `false` | no |
| <a name="input_use_existing_resource_group"></a> [use\_existing\_resource\_group](#input\_use\_existing\_resource\_group) | Whether to use an existing resource group or not | `bool` | `false` | no |
| <a name="input_username"></a> [username](#input\_username) | Username of the local user account | `string` | `"runneradmin"` | no |
| <a name="input_virtual_machine_scale_set_name"></a> [virtual\_machine\_scale\_set\_name](#input\_virtual\_machine\_scale\_set\_name) | n/a | `string` | `"self-hosted-runners"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_password"></a> [password](#output\_password) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine_scale_set.self_hosted_runners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_windows_virtual_machine_scale_set.self_hosted_runners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
<!-- END_TF_DOCS -->