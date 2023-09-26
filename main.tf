locals {
  resource_group_name = var.use_existing_resource_group ? var.resource_group_name : azurerm_resource_group.rg[0].name
  image_offer         = var.runner_platform == "azure_devops" ? "self_hosted_runner_ado" : "self_hosted_runner_github"
  image_sku           = "${var.operating_system}-latest"
  password            = var.password != null ? var.password : random_password.password[0].result
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

  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_keys
    content {
      public_key = admin_ssh_key.value
      username   = var.username
    }
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

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${var.virtual_machine_scale_set_name}-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id != null ? var.subnet_id : azurerm_subnet.vmss[0].id
    }
  }

  lifecycle {
    ignore_changes = [tags, automatic_os_upgrade_policy, instances, overprovision, single_placement_group]
  }
}

resource "azurerm_windows_virtual_machine_scale_set" "self_hosted_runners" {
  count               = var.operating_system == "windows" ? 1 : 0
  name                = var.virtual_machine_scale_set_name
  location            = var.location
  resource_group_name = local.resource_group_name
  sku                 = var.sku
  instances           = 0
  admin_username      = var.username
  admin_password      = local.password
  tags                = var.tags
  upgrade_mode        = "Automatic"

  source_image_reference {
    publisher = "amestofortytwoas1653635920536"
    offer     = local.image_offer
    sku       = local.image_sku
    version   = "latest"
  }

  plan {
    publisher = "amestofortytwoas1653635920536"
    product   = local.image_offer
    name      = local.image_sku
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${var.virtual_machine_scale_set_name}-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id != null ? var.subnet_id : azurerm_subnet.vmss[0].id
    }
  }

  lifecycle {
    ignore_changes = [tags, automatic_os_upgrade_policy, instances, overprovision, single_placement_group]
  }
}
