<!-- BEGIN_TF_DOCS -->


<!-- markdownlint-disable MD033 -->
## Requirements

No requirements.

## Examples

### Basic example

```hcl

```

### Advanced Example

```hcl

```

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| random | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_outbound_rule.outbound_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_outbound_rule) | resource |
| [azurerm_linux_virtual_machine_scale_set.self_hosted_runners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_public_ip.load_balancer_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_windows_virtual_machine_scale_set.self_hosted_runners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deploy\_load\_balancer | (Optional) When using the built-in network (use\_custom\_subnet is false), should we create a NAT gateway? This will be required in the future. Defaults to false. | `bool` | `false` | no |
| enable\_accelerated\_networking | (Optional) Does this Network Interface support Accelerated Networking? Possible values are true and false. Defaults to false. | `bool` | `false` | no |
| enable\_automatic\_instance\_repair | Enable automatic instance repair for the VMSS. This will automatically repair instances that fail health checks. | `bool` | `false` | no |
| enable\_termination\_notifications | Enable termination notifications for the VMSS. This will send a notification to the Azure Instance Metadata Service (IMDS) when the VMSS is scheduled for maintenance or when the VMSS is deleted. | `bool` | `false` | no |
| load\_balancer\_backend\_address\_pool\_id | (Optional) Value of the backend address pool id to use for the load balancer. I.e. for static outbound NAT. | `string` | `""` | no |
| location | The Azure region to create the scale set in | `string` | `"westeurope"` | no |
| operating\_system | The OS of the runners | `string` | `"ubuntu"` | no |
| password | Password of the local user acocunt | `string` | `null` | no |
| resource\_group\_name | The resource group name to create | `string` | `"self-hosted-runners"` | no |
| runner\_platform | Whether it is github or azure\_devops used for runners | `string` | `"azure_devops"` | no |
| sku | The sku to create virtual machines with | `string` | `"Standard_D2s_v3"` | no |
| ssh\_public\_keys | n/a | `list(string)` | `[]` | no |
| subnet\_id | When provided, this subnet will be used for the scale set, rather than creating a new virtual network and subnet | `string` | `null` | no |
| tags | n/a | `map(any)` | `{}` | no |
| use\_custom\_subnet | Set to true if subnet\_id is provided in order to actually use it (works around a TF issue) | `bool` | `false` | no |
| use\_existing\_resource\_group | Whether to use an existing resource group or not | `bool` | `false` | no |
| username | Username of the local user account | `string` | `"runneradmin"` | no |
| virtual\_machine\_scale\_set\_name | n/a | `string` | `"self-hosted-runners"` | no |
| vmss\_encryption\_at\_host\_enabled | Enables encryption at host for the VMSS virtual machines. In order to use this option, the EncryptionAtHost feature must be enabled for Microsoft.Compue resource provider must be enabled for the subscription. To enable, use this PowerShell command: Register-AzProviderFeature -FeatureName 'EncryptionAtHost' -ProviderNamespace 'Microsoft.Compute'. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| password | n/a |
| virtual\_machine\_scale\_set\_id | n/a |


## Modules

No modules.

<!-- END_TF_DOCS -->