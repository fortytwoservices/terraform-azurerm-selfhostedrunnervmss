locals {
  resource_group_name = var.use_existing_resource_group ? var.resource_group_name : azurerm_resource_group.rg[0].name
  image_offer         = var.runner_platform == "azure_devops" ? "self_hosted_runner_ado" : "self_hosted_runner_github"
  image_sku           = "${var.operating_system}-latest"
  password            = var.password != null ? var.password : random_password.password[0].result

  load_balancer_backend_address_pool_ids = var.load_balancer_backend_address_pool_id != "" ? [var.load_balancer_backend_address_pool_id] : (!var.use_custom_subnet && var.deploy_load_balancer ? [azurerm_lb_backend_address_pool.load_balancer[0].id] : null)
}

resource "random_password" "password" {
  count            = var.password == null ? 1 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_resource_group" "rg" {
  count    = var.use_existing_resource_group ? 0 : 1
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vmss" {
  count               = var.use_custom_subnet ? 0 : 1
  name                = "${var.virtual_machine_scale_set_name}-net"
  address_space       = ["10.0.0.0/24"]
  location            = var.location
  resource_group_name = local.resource_group_name
  tags                = var.tags

  depends_on = [azurerm_resource_group.rg]
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "vmss" {
  count                = var.use_custom_subnet ? 0 : 1
  name                 = "vmss"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vmss[0].name
  address_prefixes     = azurerm_virtual_network.vmss[0].address_space

  lifecycle {
    ignore_changes = [
      service_endpoints,
    ]
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "self_hosted_runners" {
  count                           = var.operating_system == "ubuntu" ? 1 : 0
  name                            = var.virtual_machine_scale_set_name
  location                        = var.location
  resource_group_name             = local.resource_group_name
  sku                             = var.sku
  instances                       = 0
  admin_username                  = var.username
  admin_password                  = length(var.ssh_public_keys) == 0 ? local.password : null
  disable_password_authentication = length(var.ssh_public_keys) > 0
  tags                            = var.tags
  upgrade_mode                    = "Manual"
  overprovision                   = false
  encryption_at_host_enabled      = var.vmss_encryption_at_host_enabled


  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_keys
    content {
      public_key = admin_ssh_key.value
      username   = var.username
    }
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  plan {
    publisher = "amestofortytwoas1653635920536"
    product   = local.image_offer
    name      = local.image_sku
  }

  source_image_reference {
    publisher = "amestofortytwoas1653635920536"
    offer     = local.image_offer
    sku       = local.image_sku
    version   = "latest"
  }

  dynamic "scale_in" {
    for_each = var.scale_in != null ? [1] : []
    content {
      force_deletion_enabled = scale_in.value.force_deletion_enabled
      rule                   = scale_in.value.rule
    }
  }

  dynamic "termination_notification" {
    for_each = var.enable_termination_notifications ? [1] : []
    content {
      enabled = true
      timeout = "PT5M"
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.enable_automatic_instance_repair ? [1] : []
    content {
      enabled      = true
      grace_period = "PT10M"
    }
  }

  dynamic "extension" {
    for_each = var.enable_automatic_instance_repair ? [1] : []
    content {
      name                 = "HealthExtension"
      publisher            = "Microsoft.ManagedServices"
      type                 = "ApplicationHealthLinux"
      type_handler_version = "1.0"

      settings = <<SETTINGS
      {
        "protocol": "tcp",
        "port": 22,
        "intervalInSeconds": 5,
        "numberOfProbes": 1
      }
      SETTINGS
    }

  }

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = "${var.virtual_machine_scale_set_name}-nic"
    primary                       = true
    enable_accelerated_networking = var.enable_accelerated_networking
    network_security_group_id     = var.network_security_group_id

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.subnet_id != null ? var.subnet_id : azurerm_subnet.vmss[0].id
      load_balancer_backend_address_pool_ids = local.load_balancer_backend_address_pool_ids
    }
  }

  lifecycle {
    ignore_changes = [tags, automatic_os_upgrade_policy, instances, overprovision, single_placement_group]
  }
}

resource "azurerm_windows_virtual_machine_scale_set" "self_hosted_runners" {
  count                      = var.operating_system == "windows" ? 1 : 0
  name                       = var.virtual_machine_scale_set_name
  location                   = var.location
  resource_group_name        = local.resource_group_name
  sku                        = var.sku
  instances                  = 0
  admin_username             = var.username
  admin_password             = local.password
  tags                       = var.tags
  upgrade_mode               = "Manual"
  overprovision              = false
  encryption_at_host_enabled = var.vmss_encryption_at_host_enabled

  source_image_reference {
    publisher = "amestofortytwoas1653635920536"
    offer     = local.image_offer
    sku       = local.image_sku
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  plan {
    publisher = "amestofortytwoas1653635920536"
    product   = local.image_offer
    name      = local.image_sku
  }

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = "${var.virtual_machine_scale_set_name}-nic"
    primary                       = true
    enable_accelerated_networking = var.enable_accelerated_networking
    network_security_group_id     = var.network_security_group_id

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.subnet_id != null ? var.subnet_id : azurerm_subnet.vmss[0].id
      load_balancer_backend_address_pool_ids = local.load_balancer_backend_address_pool_ids
    }
  }

  dynamic "scale_in" {
    for_each = var.scale_in != null ? [1] : []
    content {
      force_deletion_enabled = var.scale_in.force_deletion_enabled
      rule                   = var.scale_in.rule
    }
  }

  lifecycle {
    ignore_changes = [tags, automatic_os_upgrade_policy, instances, overprovision, single_placement_group]
  }
}

# Public IP address for NAT gateway
resource "azurerm_public_ip" "load_balancer_pip" {
  count               = !var.use_custom_subnet && var.deploy_load_balancer ? 1 : 0
  name                = "${var.virtual_machine_scale_set_name}-lb-pip"
  location            = var.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load balancer
resource "azurerm_lb" "load_balancer" {
  count               = !var.use_custom_subnet && var.deploy_load_balancer ? 1 : 0
  name                = "${var.virtual_machine_scale_set_name}-lb"
  location            = var.location
  resource_group_name = local.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.load_balancer_pip[0].id
  }
}

resource "azurerm_lb_backend_address_pool" "load_balancer" {
  count           = !var.use_custom_subnet && var.deploy_load_balancer ? 1 : 0
  loadbalancer_id = azurerm_lb.load_balancer[0].id
  name            = "backend"
}

resource "azurerm_lb_outbound_rule" "outbound_rule" {
  count                   = !var.use_custom_subnet && var.deploy_load_balancer ? 1 : 0
  name                    = "OutboundRule"
  loadbalancer_id         = azurerm_lb.load_balancer[0].id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.load_balancer[0].id

  frontend_ip_configuration {
    name = "PublicIPAddress"
  }
}
