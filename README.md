<!-- BEGIN_TF_DOCS -->
# Self Hosted Runners Virtual Machine Scale Set

| :exclamation:  NB! |
|---|
| Due to the renaming of Company, the Github organization has changed name from "amestofortytwo" to "fortytwoservices". Pre-existing Terraform code would need to change that in code. |

This module deploys a virtual machine scale set for self hosted runners for Azure DevOps and GitHub.

```hcl
provider "azurerm" {
  features {}
}

module "vmss" {
  source                         = "fortytwoservices/selfhostedrunnervmss/azurerm"
  operating_system               = "ubuntu"       # windows or ubuntu
  runner_platform                = "azure_devops" # azure_devops or github
}
```

After deploying the virtual machine scale set, you need to configure the Azure DevOps or GitHub side of things according to our documentation:

- [Configure Azure DevOps Agent Pool](https://docs.fortytwo.io/Self%20Hosted%20Runners/Azure%20DevOps/step2/)
- [Configure GitHub](https://docs.fortytwo.io/Self%20Hosted%20Runners/GitHub/step2/)

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.5.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.114.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.6.2)

## Examples

### Basic example

```hcl
terraform {
  required_version = ">=1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "vmss" {
  source               = "fortytwoservices/selfhostedrunnervmss/azurerm"
  version              = "1.6.0"
  operating_system     = "ubuntu"       # windows or ubuntu
  runner_platform      = "azure_devops" # azure_devops or github
  deploy_load_balancer = true
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
```

### Advanced Example

```hcl
terraform {
  required_version = ">=1.4.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.100.0"
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
  source                          = "fortytwoservices/selfhostedrunnervmss/azurerm"
  version                         = "1.6.0"
  operating_system                = "ubuntu"       # windows or ubuntu
  runner_platform                 = "azure_devops" # azure_devops or github
  resource_group_name             = azurerm_resource_group.rg.name
  use_existing_resource_group     = true
  location                        = azurerm_resource_group.rg.location
  virtual_machine_scale_set_name  = "runners"
  sku                             = "Standard_D2s_v3"
  ssh_public_keys                 = ["ssh-rsa AAAAB3NzaC1yc2EAAAADA....QFv2PJ0= marius@42device"]
  subnet_id                       = azurerm_subnet.vmss.id
  use_custom_subnet               = true
  vmss_encryption_at_host_enabled = true
}

output "password" {
  value = nonsensitive(module.vmss.password)
}
```

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.114.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.6.2)

## Resources

The following resources are used by this module:

- [azurerm_lb.load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) (resource)
- [azurerm_lb_backend_address_pool.load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) (resource)
- [azurerm_lb_outbound_rule.outbound_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_outbound_rule) (resource)
- [azurerm_linux_virtual_machine_scale_set.self_hosted_runners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) (resource)
- [azurerm_nat_gateway.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) (resource)
- [azurerm_nat_gateway_public_ip_association.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) (resource)
- [azurerm_public_ip.load_balancer_ng](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_public_ip.load_balancer_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_subnet.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet_nat_gateway_association.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) (resource)
- [azurerm_virtual_network.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_windows_virtual_machine_scale_set.self_hosted_runners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) (resource)
- [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_deploy_load_balancer"></a> [deploy\_load\_balancer](#input\_deploy\_load\_balancer)

Description: (Optional) When using the built-in network (use\_custom\_subnet is false), should we create a NAT gateway? This will be required in the future. Defaults to false.

Type: `bool`

Default: `false`

### <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking)

Description: (Optional) Does this Network Interface support Accelerated Networking? Possible values are true and false. Defaults to false.

Type: `bool`

Default: `false`

### <a name="input_enable_automatic_instance_repair"></a> [enable\_automatic\_instance\_repair](#input\_enable\_automatic\_instance\_repair)

Description: Enable automatic instance repair for the VMSS. This will automatically repair instances that fail health checks.

Type: `bool`

Default: `false`

### <a name="input_enable_termination_notifications"></a> [enable\_termination\_notifications](#input\_enable\_termination\_notifications)

Description: Enable termination notifications for the VMSS. This will send a notification to the Azure Instance Metadata Service (IMDS) when the VMSS is scheduled for maintenance or when the VMSS is deleted.

Type: `bool`

Default: `false`

### <a name="input_identity"></a> [identity](#input\_identity)

Description: (Optional) If SystemAssigned, UserAssigned or both should be enabled for the Virtual Machine Scale Set

Type:

```hcl
object({
    type         = string
    identity_ids = optional(list(string))
  })
```

Default: `null`

### <a name="input_load_balancer_backend_address_pool_id"></a> [load\_balancer\_backend\_address\_pool\_id](#input\_load\_balancer\_backend\_address\_pool\_id)

Description: (Optional) Value of the backend address pool id to use for the load balancer. I.e. for static outbound NAT.

Type: `string`

Default: `""`

### <a name="input_location"></a> [location](#input\_location)

Description: The Azure region to create the scale set in

Type: `string`

Default: `"westeurope"`

### <a name="input_nat_gateway"></a> [nat\_gateway](#input\_nat\_gateway)

Description: When enabled, a NAT gateway will be created and associated with the scale set. The NAT gateway will be created in the same resource group as the scale set.

Type:

```hcl
object({
    enabled                 = optional(bool, false)
    sku_name                = optional(string, "Standard")
    idle_timeout_in_minutes = optional(number, 4)
    zones                   = optional(list(string))
  })
```

Default: `{}`

### <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id)

Description: (Optional) Use an existing network security group on the VMSS network interface card. Defaults to null.

Type: `string`

Default: `null`

### <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system)

Description: The OS of the runners

Type: `string`

Default: `"ubuntu"`

### <a name="input_os_disk_caching"></a> [os\_disk\_caching](#input\_os\_disk\_caching)

Description: (Optional) The caching type for the OS disk. Default is ReadWrite.

Type: `string`

Default: `"ReadWrite"`

### <a name="input_os_disk_diff_disk_settings"></a> [os\_disk\_diff\_disk\_settings](#input\_os\_disk\_diff\_disk\_settings)

Description: (Optional) The settings for the OS disk's differential disk. Gives the possiblity to enable ephemeral os disk. If enabled it also requires `os_disk_caching` to be set to "ReadOnly". Defaults to block not being set.  
object({  
  option    = (Optional) The option for the differential disk. Possible values are "Local". Defaults to null.  
  placement = (Optional) The placement of the differential disk. Possible values are "CacheDisk" and "ResourceDisk". Defaults to "ResourceDisk".
})

Type:

```hcl
object({
    option    = optional(string)
    placement = optional(string, "ResourceDisk")
  })
```

Default: `{}`

### <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb)

Description: (Optional) The size of the OS disk in GB. Default is the size of the image used.

Type: `number`

Default: `null`

### <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type)

Description: (Optional) The type of storage account to use for the OS disk. Default is Standard\_LRS.

Type: `string`

Default: `"Standard_LRS"`

### <a name="input_override_image_sku"></a> [override\_image\_sku](#input\_override\_image\_sku)

Description: (Optional) The SKU of the image to use for the VMSS instances. Image SKU default to `operating_system`-latest. Currently supported values are:  
Windows: "windows-latest", "windows-2025", "windows-2022", "windows-2019"  
Ubuntu: "ubuntu-latest", "ubuntu-24.04", "ubuntu-20.04"

Type: `string`

Default: `null`

### <a name="input_password"></a> [password](#input\_password)

Description: Password of the local user acocunt

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group name to create

Type: `string`

Default: `"self-hosted-runners"`

### <a name="input_runner_platform"></a> [runner\_platform](#input\_runner\_platform)

Description: Whether it is github or azure\_devops used for runners

Type: `string`

Default: `"azure_devops"`

### <a name="input_scale_in"></a> [scale\_in](#input\_scale\_in)

Description: object({  
  force\_deletion\_enabled = (Optional) If true, the VMSS will force delete the VM instance when it is being scaled in. Defaults to false.  
  rule                   = (Optional) Scale-in policy for the VMSS. If not provided, the default scale-in policy will be used. Possible values are Default, NewestVM, OldestVM, and Custom. Defaults to Default.
})

Type:

```hcl
object({
    force_deletion_enabled = optional(bool, false)
    rule                   = optional(string, "Default")
  })
```

Default: `null`

### <a name="input_sku"></a> [sku](#input\_sku)

Description: The sku to create virtual machines with

Type: `string`

Default: `"Standard_D2s_v3"`

### <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys)

Description: (Optional) A list of SSH public keys to add to the VMSS instances

Type: `list(string)`

Default: `[]`

### <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id)

Description: When provided, this subnet will be used for the scale set, rather than creating a new virtual network and subnet

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) A mapping of tags to assign to the resources

Type: `map(any)`

Default: `{}`

### <a name="input_use_custom_subnet"></a> [use\_custom\_subnet](#input\_use\_custom\_subnet)

Description: Set to true if subnet\_id is provided in order to actually use it (works around a TF issue)

Type: `bool`

Default: `false`

### <a name="input_use_existing_resource_group"></a> [use\_existing\_resource\_group](#input\_use\_existing\_resource\_group)

Description: Whether to use an existing resource group or not

Type: `bool`

Default: `false`

### <a name="input_username"></a> [username](#input\_username)

Description: Username of the local user account

Type: `string`

Default: `"runneradmin"`

### <a name="input_virtual_machine_scale_set_name"></a> [virtual\_machine\_scale\_set\_name](#input\_virtual\_machine\_scale\_set\_name)

Description: (Optional) The name used for the virtual machine scale set

Type: `string`

Default: `"self-hosted-runners"`

### <a name="input_vmss_encryption_at_host_enabled"></a> [vmss\_encryption\_at\_host\_enabled](#input\_vmss\_encryption\_at\_host\_enabled)

Description: Enables encryption at host for the VMSS virtual machines. In order to use this option, the EncryptionAtHost feature must be enabled for Microsoft.Compue resource provider must be enabled for the subscription. To enable, use this PowerShell command: Register-AzProviderFeature -FeatureName 'EncryptionAtHost' -ProviderNamespace 'Microsoft.Compute'.

Type: `bool`

Default: `false`

## Outputs

The following outputs are exported:

### <a name="output_password"></a> [password](#output\_password)

Description: n/a

### <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id)

Description: n/a

### <a name="output_virtual_machine_scale_set_id"></a> [virtual\_machine\_scale\_set\_id](#output\_virtual\_machine\_scale\_set\_id)

Description: n/a

### <a name="output_virtual_machine_scale_set_identity_principal_id"></a> [virtual\_machine\_scale\_set\_identity\_principal\_id](#output\_virtual\_machine\_scale\_set\_identity\_principal\_id)

Description: n/a

## Modules

No modules.

<!-- END_TF_DOCS -->