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

After deploying the virtual machine scale set, you need to configure the Azure DevOps or GitHub side of things according to our documentation:

- [Configure Azure DevOps Agent Pool](https://docs.byfortytwo.com/Self%20Hosted%20Runners/Azure%20DevOps/step2/)
- [Configure GitHub](https://docs.byfortytwo.com/Self%20Hosted%20Runners/GitHub/step2/)

<!-- markdownlint-disable MD033 -->
## Requirements

No requirements.

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
  source               = "amestofortytwo/selfhostedrunnervmss/azurerm"
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
  source                          = "amestofortytwo/selfhostedrunnervmss/azurerm"
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

- azurerm

- random

## Resources

The following resources are used by this module:

- [azurerm_lb.load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) (resource)
- [azurerm_lb_backend_address_pool.load_balancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) (resource)
- [azurerm_lb_outbound_rule.outbound_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_outbound_rule) (resource)
- [azurerm_linux_virtual_machine_scale_set.self_hosted_runners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) (resource)
- [azurerm_public_ip.load_balancer_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_subnet.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_windows_virtual_machine_scale_set.self_hosted_runners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) (resource)
- [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### deploy\_load\_balancer

Description: (Optional) When using the built-in network (use\_custom\_subnet is false), should we create a NAT gateway? This will be required in the future. Defaults to false.

Type: `bool`

Default: `false`

### enable\_accelerated\_networking

Description: (Optional) Does this Network Interface support Accelerated Networking? Possible values are true and false. Defaults to false.

Type: `bool`

Default: `false`

### enable\_automatic\_instance\_repair

Description: Enable automatic instance repair for the VMSS. This will automatically repair instances that fail health checks.

Type: `bool`

Default: `false`

### enable\_termination\_notifications

Description: Enable termination notifications for the VMSS. This will send a notification to the Azure Instance Metadata Service (IMDS) when the VMSS is scheduled for maintenance or when the VMSS is deleted.

Type: `bool`

Default: `false`

### load\_balancer\_backend\_address\_pool\_id

Description: (Optional) Value of the backend address pool id to use for the load balancer. I.e. for static outbound NAT.

Type: `string`

Default: `""`

### location

Description: The Azure region to create the scale set in

Type: `string`

Default: `"westeurope"`

### operating\_system

Description: The OS of the runners

Type: `string`

Default: `"ubuntu"`

### password

Description: Password of the local user acocunt

Type: `string`

Default: `null`

### resource\_group\_name

Description: The resource group name to create

Type: `string`

Default: `"self-hosted-runners"`

### runner\_platform

Description: Whether it is github or azure\_devops used for runners

Type: `string`

Default: `"azure_devops"`

### sku

Description: The sku to create virtual machines with

Type: `string`

Default: `"Standard_D2s_v3"`

### ssh\_public\_keys

Description: n/a

Type: `list(string)`

Default: `[]`

### subnet\_id

Description: When provided, this subnet will be used for the scale set, rather than creating a new virtual network and subnet

Type: `string`

Default: `null`

### tags

Description: n/a

Type: `map(any)`

Default: `{}`

### use\_custom\_subnet

Description: Set to true if subnet\_id is provided in order to actually use it (works around a TF issue)

Type: `bool`

Default: `false`

### use\_existing\_resource\_group

Description: Whether to use an existing resource group or not

Type: `bool`

Default: `false`

### username

Description: Username of the local user account

Type: `string`

Default: `"runneradmin"`

### virtual\_machine\_scale\_set\_name

Description: n/a

Type: `string`

Default: `"self-hosted-runners"`

### vmss\_encryption\_at\_host\_enabled

Description: Enables encryption at host for the VMSS virtual machines. In order to use this option, the EncryptionAtHost feature must be enabled for Microsoft.Compue resource provider must be enabled for the subscription. To enable, use this PowerShell command: Register-AzProviderFeature -FeatureName 'EncryptionAtHost' -ProviderNamespace 'Microsoft.Compute'.

Type: `bool`

Default: `false`

## Outputs

The following outputs are exported:

### password

Description: n/a

### virtual\_machine\_scale\_set\_id

Description: n/a


## Modules

No modules.

<!-- END_TF_DOCS -->