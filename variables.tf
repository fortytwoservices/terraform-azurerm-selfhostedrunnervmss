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
  type    = string
  default = "self-hosted-runners"
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
  type    = map(any)
  default = {}
}

variable "ssh_public_keys" {
  type    = list(string)
  default = []
}
