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
