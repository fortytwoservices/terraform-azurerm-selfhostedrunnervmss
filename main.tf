data "azurerm_client_config" "current" {}

locals {
  resource_group_name = var.use_existing_resource_group ? var.resource_group_name : azapi_resource.rg[0].name
  resource_group_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.resource_group_name}"
  image_offer         = var.runner_platform == "azure_devops" ? "self_hosted_runner_ado" : "self_hosted_runner_github"
  image_sku           = coalesce(var.override_image_sku, "${var.operating_system}-latest")
  password            = var.password != null ? var.password : random_password.password[0].result

  load_balancer_backend_address_pool_ids = var.load_balancer_backend_address_pool_id != "" ? [
    { id = var.load_balancer_backend_address_pool_id }
    ] : (!var.use_custom_subnet && var.deploy_load_balancer ? [
      { id = azapi_resource.lb_backend_address_pool[0].id }
  ] : [])
}

resource "random_password" "password" {
  count            = var.password == null ? 1 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azapi_resource" "rg" {
  count    = var.use_existing_resource_group ? 0 : 1
  type     = "Microsoft.Resources/resourceGroups@2024-03-01"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azapi_resource" "vmss_vnet" {
  count                = var.use_custom_subnet ? 0 : 1
  type                 = "Microsoft.Network/virtualNetworks@2025-03-01"
  name                 = "${var.virtual_machine_scale_set_name}-net"
  parent_id            = local.resource_group_id
  location             = var.location
  tags                 = var.tags
  ignore_null_property = true
  body = {
    properties = {
      addressSpace = {
        addressPrefixes = ["10.0.0.0/24"]
      }
      dhcpOptions = {
        dnsServers = []
      }
      enableDdosProtection        = false
      privateEndpointVNetPolicies = "Disabled"
      virtualNetworkPeerings      = []
    }
  }
  lifecycle {
    ignore_changes = [body.properties.subnets]
  }
}

resource "azapi_resource" "vmss_subnet" {
  count     = var.use_custom_subnet ? 0 : 1
  type      = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"
  name      = "vmss"
  parent_id = azapi_resource.vmss_vnet[0].id
  body = {
    properties = {
      addressPrefix = "10.0.0.0/24"
      natGateway = var.nat_gateway.enabled ? {
        id = azapi_resource.nat_gateway["vmss"].id
      } : null
    }
  }
}

resource "azapi_resource" "vmss_linux" {
  count                = var.operating_system == "ubuntu" ? 1 : 0
  type                 = "Microsoft.Compute/virtualMachineScaleSets@2025-04-01"
  name                 = var.virtual_machine_scale_set_name
  parent_id            = local.resource_group_id
  location             = var.location
  tags                 = var.tags
  ignore_null_property = true

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  body = {
    sku = {
      name     = var.sku
      tier     = "Standard"
      capacity = 0
    }
    plan = {
      publisher = "amestofortytwoas1653635920536"
      product   = local.image_offer
      name      = local.image_sku
    }
    properties = {
      overprovision = false
      upgradePolicy = {
        mode = "Manual"
      }
      virtualMachineProfile = {
        osProfile = {
          computerNamePrefix = var.virtual_machine_scale_set_name
          adminUsername      = var.username
          adminPassword      = length(var.ssh_public_keys) == 0 ? local.password : null
          linuxConfiguration = {
            disablePasswordAuthentication = length(var.ssh_public_keys) > 0
            ssh = {
              publicKeys = [for k in var.ssh_public_keys : {
                path    = "/home/${var.username}/.ssh/authorized_keys"
                keyData = k
              }]
            }
          }
        }
        storageProfile = {
          imageReference = {
            publisher = "amestofortytwoas1653635920536"
            offer     = local.image_offer
            sku       = local.image_sku
            version   = var.override_image_sku_version
          }
          osDisk = {
            createOption = "FromImage" # Required for VMSS
            caching      = var.os_disk_caching
            managedDisk = {
              storageAccountType = var.os_disk_storage_account_type
            }
            diskSizeGB = var.os_disk_size_gb
            diffDiskSettings = try(var.os_disk_diff_disk_settings.option, null) != null ? {
              option    = var.os_disk_diff_disk_settings.option
              placement = var.os_disk_diff_disk_settings.placement
            } : null
          }
        }
        networkProfile = {
          networkInterfaceConfigurations = [{
            name = "${var.virtual_machine_scale_set_name}-nic"
            properties = {
              primary                 = true
              disableTcpStateTracking = false
              dnsSettings = {
                dnsServers = []
              }
              enableAcceleratedNetworking = var.enable_accelerated_networking
              enableIPForwarding          = false
              networkSecurityGroup = var.network_security_group_id != null ? {
                id = var.network_security_group_id
              } : null
              ipConfigurations = [{
                name = "internal"
                properties = {
                  primary                 = true
                  privateIPAddressVersion = "IPv4"
                  subnet = {
                    id = var.subnet_id != null ? var.subnet_id : azapi_resource.vmss_subnet[0].id
                  }

                  loadBalancerBackendAddressPools = local.load_balancer_backend_address_pool_ids
                }
              }]
            }
          }]
        }
        securityProfile = {
          encryptionAtHost = var.vmss_encryption_at_host_enabled
        }
        diagnosticsProfile = {
          bootDiagnostics = {
            enabled    = true
            storageUri = null
          }
        }
        extensionProfile = {
          extensions = var.enable_automatic_instance_repair ? [{
            name = "HealthExtension"
            properties = {
              publisher          = "Microsoft.ManagedServices"
              type               = "ApplicationHealthLinux"
              typeHandlerVersion = "1.0"
              settings = {
                protocol          = "tcp"
                port              = 22
                intervalInSeconds = 5
                numberOfProbes    = 1
              }
            }
          }] : []
        }

        scheduledEventsProfile = var.enable_termination_notifications ? {
          terminationNotificationProfile = { // Correct nesting
            enable           = true
            notBeforeTimeout = "PT5M"
          }
        } : null
      }
      scaleInPolicy = var.scale_in != null ? {
        rules         = [var.scale_in.rule]
        forceDeletion = var.scale_in.force_deletion_enabled
      } : null
      automaticRepairsPolicy = var.enable_automatic_instance_repair ? {
        enabled     = true
        gracePeriod = "PT10M"
      } : null
    }
  }

  lifecycle {
    ignore_changes = [tags, body.sku.capacity, body.properties.virtualMachineProfile.extensionProfile]
  }
}

resource "azapi_resource" "vmss_windows" {
  count                = var.operating_system == "windows" ? 1 : 0
  type                 = "Microsoft.Compute/virtualMachineScaleSets@2025-04-01"
  name                 = var.virtual_machine_scale_set_name
  parent_id            = local.resource_group_id
  location             = var.location
  tags                 = var.tags
  ignore_null_property = true

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  body = {
    sku = {
      name     = var.sku
      tier     = "Standard"
      capacity = 0
    }
    plan = {
      publisher = "amestofortytwoas1653635920536"
      product   = local.image_offer
      name      = local.image_sku
    }
    properties = {
      overprovision = false
      upgradePolicy = {
        mode = "Manual"
      }
      virtualMachineProfile = {
        osProfile = {
          computerNamePrefix = var.virtual_machine_scale_set_name
          adminUsername      = var.username
          adminPassword      = local.password
        }
        storageProfile = {
          imageReference = {
            publisher = "amestofortytwoas1653635920536"
            offer     = local.image_offer
            sku       = local.image_sku
            version   = var.override_image_sku_version
          }
          osDisk = {
            createOption = "FromImage"
            caching      = var.os_disk_caching
            managedDisk = {
              storageAccountType = var.os_disk_storage_account_type
            }
            diskSizeGB = var.os_disk_size_gb
            diffDiskSettings = try(var.os_disk_diff_disk_settings.option, null) != null ? {
              option    = var.os_disk_diff_disk_settings.option
              placement = var.os_disk_diff_disk_settings.placement
            } : null
          }
        }
        networkProfile = {
          networkInterfaceConfigurations = [{
            name = "${var.virtual_machine_scale_set_name}-nic"
            properties = {
              primary                     = true
              enableAcceleratedNetworking = var.enable_accelerated_networking
              networkSecurityGroup = var.network_security_group_id != null ? {
                id = var.network_security_group_id
              } : null
              ipConfigurations = [{
                name = "internal"
                properties = {
                  primary = true
                  subnet = {
                    id = var.subnet_id != null ? var.subnet_id : azapi_resource.vmss_subnet[0].id
                  }
                  loadBalancerBackendAddressPools = local.load_balancer_backend_address_pool_ids
                }
              }]
            }
          }]
        }
        securityProfile = {
          encryptionAtHost = var.vmss_encryption_at_host_enabled
        }
        diagnosticsProfile = {
          bootDiagnostics = {
            enabled    = true
            storageUri = null
          }
        }
      }
      scaleInPolicy = var.scale_in != null ? {
        rules         = [var.scale_in.rule]
        forceDeletion = var.scale_in.force_deletion_enabled
      } : null
    }
  }

  lifecycle {
    ignore_changes = [tags, body.sku.capacity, body.properties.virtualMachineProfile.extensionProfile]
  }
}

resource "azapi_resource" "public_ip_nat" {
  for_each  = !var.use_custom_subnet && var.nat_gateway.enabled ? toset(["vmss"]) : []
  type      = "Microsoft.Network/publicIPAddresses@2024-05-01"
  name      = "pip-${var.virtual_machine_scale_set_name}"
  parent_id = local.resource_group_id
  location  = var.location
  body = {
    sku = { name = "Standard" }
    properties = {
      publicIPAllocationMethod = "Static"
    }
  }
}

resource "azapi_resource" "nat_gateway" {
  for_each  = var.nat_gateway.enabled ? toset(["vmss"]) : []
  type      = "Microsoft.Network/natGateways@2024-05-01"
  name      = "ng-${var.virtual_machine_scale_set_name}"
  parent_id = local.resource_group_id
  location  = var.location
  body = {
    sku = { name = var.nat_gateway.sku_name }
    properties = {
      idleTimeoutInMinutes = var.nat_gateway.idle_timeout_in_minutes
      publicIpAddresses = !var.use_custom_subnet ? [{
        id = azapi_resource.public_ip_nat["vmss"].id
      }] : []
    }
    zones = var.nat_gateway.zones
  }
}

resource "azapi_resource" "public_ip_lb" {
  count     = !var.use_custom_subnet && var.deploy_load_balancer ? 1 : 0
  type      = "Microsoft.Network/publicIPAddresses@2024-05-01"
  name      = "${var.virtual_machine_scale_set_name}-lb-pip"
  parent_id = local.resource_group_id
  location  = var.location
  body = {
    sku = { name = "Standard" }
    properties = {
      publicIPAllocationMethod = "Static"
    }
  }
}

resource "azapi_resource" "load_balancer" {
  count     = !var.use_custom_subnet && var.deploy_load_balancer ? 1 : 0
  type      = "Microsoft.Network/loadBalancers@2024-05-01"
  name      = "${var.virtual_machine_scale_set_name}-lb"
  parent_id = local.resource_group_id
  location  = var.location
  body = {
    sku = { name = "Standard" }
    properties = {
      frontendIPConfigurations = [{
        name = "PublicIPAddress"
        properties = {
          publicIPAddress = {
            id = azapi_resource.public_ip_lb[0].id
          }
        }
      }]
    }
  }
}

resource "azapi_resource" "lb_backend_address_pool" {
  count     = !var.use_custom_subnet && var.deploy_load_balancer ? 1 : 0
  type      = "Microsoft.Network/loadBalancers/backendAddressPools@2024-05-01"
  name      = "backend"
  parent_id = azapi_resource.load_balancer[0].id
  body      = {}
}

resource "azapi_resource" "lb_outbound_rule" {
  count                     = !var.use_custom_subnet && var.deploy_load_balancer ? 1 : 0
  type                      = "Microsoft.Network/loadBalancers/outboundRules@2024-05-01"
  name                      = "OutboundRule"
  parent_id                 = azapi_resource.load_balancer[0].id
  schema_validation_enabled = false
  body = {
    properties = {
      protocol = "All"
      backendAddressPool = {
        id = azapi_resource.lb_backend_address_pool[0].id
      }
      frontendIPConfigurations = [{
        id = "${azapi_resource.load_balancer[0].id}/frontendIPConfigurations/PublicIPAddress"
      }]
    }
  }
}

# Moved blocks to attempt state migration
moved {
  from = azurerm_resource_group.rg
  to   = azapi_resource.rg
}

moved {
  from = azurerm_virtual_network.vmss
  to   = azapi_resource.vmss_vnet
}

moved {
  from = azurerm_subnet.vmss
  to   = azapi_resource.vmss_subnet
}

moved {
  from = azurerm_linux_virtual_machine_scale_set.self_hosted_runners
  to   = azapi_resource.vmss_linux
}

moved {
  from = azurerm_windows_virtual_machine_scale_set.self_hosted_runners
  to   = azapi_resource.vmss_windows
}

moved {
  from = azurerm_public_ip.load_balancer_ng
  to   = azapi_resource.public_ip_nat
}

moved {
  from = azurerm_nat_gateway.vmss
  to   = azapi_resource.nat_gateway
}

moved {
  from = azurerm_public_ip.load_balancer_pip
  to   = azapi_resource.public_ip_lb
}

moved {
  from = azurerm_lb.load_balancer
  to   = azapi_resource.load_balancer
}

moved {
  from = azurerm_lb_backend_address_pool.load_balancer
  to   = azapi_resource.lb_backend_address_pool
}

moved {
  from = azurerm_lb_outbound_rule.outbound_rule
  to   = azapi_resource.lb_outbound_rule
}

# The following resources are now embedded in parent resource properties and will be removed from state.
# They require manual state removal or will be destroyed. `moved` cannot handle removal.
# azurerm_nat_gateway_public_ip_association.vmss
# azurerm_subnet_nat_gateway_association.vmss

