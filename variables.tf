variable "resource_group_name" {
  type        = string
  default     = "self-hosted-runners"
  description = "The resource group name to create"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "The Azure region to create the scale set in"
}

variable "use_existing_resource_group" {
  type        = bool
  default     = false
  description = "Whether to use an existing resource group or not"
}

variable "virtual_machine_scale_set_name" {
  type        = string
  default     = "self-hosted-runners"
  description = "(Optional) The name used for the virtual machine scale set"
}

variable "use_custom_subnet" {
  type        = bool
  default     = false
  description = "Set to true if subnet_id is provided in order to actually use it (works around a TF issue)"
}

variable "subnet_id" {
  type        = string
  description = "When provided, this subnet will be used for the scale set, rather than creating a new virtual network and subnet"
  default     = null
}

variable "operating_system" {
  type        = string
  description = "The OS of the runners"
  default     = "ubuntu"
  validation {
    condition     = var.operating_system == "ubuntu" || var.operating_system == "windows"
    error_message = "Valid values for operating_system are: windows, ubuntu"
  }
}

variable "override_image_sku" {
  type        = string
  description = "The SKU of the image to use for the VMSS instances"
  default     = null
}

variable "runner_platform" {
  type        = string
  description = "Whether it is github or azure_devops used for runners"
  default     = "azure_devops"
  validation {
    condition     = var.runner_platform == "azure_devops" || var.runner_platform == "github"
    error_message = "Valid values for runner_platform are: azure_devops, github"
  }
}

variable "sku" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "The sku to create virtual machines with"
}

variable "os_disk_size_gb" {
  type        = number
  default     = null
  description = "(Optional) The size of the OS disk in GB. Default is the size of the image used."
}

variable "os_disk_storage_account_type" {
  type        = string
  default     = "Standard_LRS"
  description = "(Optional) The type of storage account to use for the OS disk. Default is Standard_LRS."
}

variable "username" {
  type        = string
  default     = "runneradmin"
  description = "Username of the local user account"
}

variable "password" {
  type        = string
  default     = null
  description = "Password of the local user acocunt"
  sensitive   = true
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resources"
}

variable "ssh_public_keys" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of SSH public keys to add to the VMSS instances"
}

variable "load_balancer_backend_address_pool_id" {
  description = "(Optional) Value of the backend address pool id to use for the load balancer. I.e. for static outbound NAT."
  type        = string
  default     = ""
}

variable "vmss_encryption_at_host_enabled" {
  type        = bool
  default     = false # Will be updated to default to true on next major release
  description = "Enables encryption at host for the VMSS virtual machines. In order to use this option, the EncryptionAtHost feature must be enabled for Microsoft.Compue resource provider must be enabled for the subscription. To enable, use this PowerShell command: Register-AzProviderFeature -FeatureName 'EncryptionAtHost' -ProviderNamespace 'Microsoft.Compute'."
}

variable "enable_termination_notifications" {
  type        = bool
  default     = false # Will be updated to default to true on next major release
  description = "Enable termination notifications for the VMSS. This will send a notification to the Azure Instance Metadata Service (IMDS) when the VMSS is scheduled for maintenance or when the VMSS is deleted."
}

variable "enable_automatic_instance_repair" {
  type        = bool
  default     = false # Will be updated to default to true on next major release
  description = "Enable automatic instance repair for the VMSS. This will automatically repair instances that fail health checks."
}

variable "enable_accelerated_networking" {
  type        = bool
  default     = false
  description = "(Optional) Does this Network Interface support Accelerated Networking? Possible values are true and false. Defaults to false."
}

variable "deploy_load_balancer" {
  type        = bool
  default     = false
  description = "(Optional) When using the built-in network (use_custom_subnet is false), should we create a NAT gateway? This will be required in the future. Defaults to false."
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default     = null
  description = "(Optional) If SystemAssigned, UserAssigned or both should be enabled for the Virtual Machine Scale Set"
}

variable "scale_in" {
  type = object({
    force_deletion_enabled = optional(bool, false)
    rule                   = optional(string, "Default")
  })
  default     = null
  description = <<-EOF
    object({
      force_deletion_enabled = (Optional) If true, the VMSS will force delete the VM instance when it is being scaled in. Defaults to false.
      rule                   = (Optional) Scale-in policy for the VMSS. If not provided, the default scale-in policy will be used. Possible values are Default, NewestVM, OldestVM, and Custom. Defaults to Default.
    })
  EOF
}

variable "network_security_group_id" {
  type        = string
  default     = null
  description = "(Optional) Use an existing network security group on the VMSS network interface card. Defaults to null."
  nullable    = true
}
