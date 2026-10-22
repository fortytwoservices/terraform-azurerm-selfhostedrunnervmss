# Self Hosted Runners Virtual Machine Scale Set

| :exclamation: NB!                                                              |
| ------------------------------------------------------------------------------ |
| The SKU windows2019-latest is deprecated and no new versions will be released. |
| It will be retired on 2027-01-01                                               |

| :exclamation: NB!                                                 |
| ----------------------------------------------------------------- |
| ubuntu-latest tag will transition to Ubuntu 26.04 from 01.11.2026 |

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
