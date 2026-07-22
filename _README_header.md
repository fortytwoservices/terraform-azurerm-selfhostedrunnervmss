# Self Hosted Runners Virtual Machine Scale Set

| :exclamation: NB!                                                        |
| ------------------------------------------------------------------------ |
| The SKU windows2019-latest is deprecated and no new versions will be released. |
| It will be removed on 2027-06-01                                            |

| :exclamation: NB!                      |
| -------------------------------------- |
| Ubuntu 26.04 ("ubuntu-2604") has been added as preview |

| :exclamation: NB!                                                                            |
| -------------------------------------------------------------------------------------------- |
| Windows 2025 and Windows Latest images will be changed on 2026-08-01 to "windows-2025-vs2026" |

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

- [Configure Azure DevOps Agent Pool](https://docs.fortytwo.io/marketplace-offerings/self-hosted-runners/ado/step2/)
- [Configure GitHub](https://docs.fortytwo.io/marketplace-offerings/self-hosted-runners/github/step2/)
