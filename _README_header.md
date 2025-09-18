# Self Hosted Runners Virtual Machine Scale Set

| :exclamation:  NB! |
|---|
| Windows-latest image will be updated to use Windows Server 2025 in October 2025. |

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
