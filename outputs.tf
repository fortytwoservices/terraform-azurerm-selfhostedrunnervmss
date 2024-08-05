output "password" {
  value     = local.password
  sensitive = true
}

output "virtual_machine_scale_set_id" {
  value = var.operating_system == "ubuntu" ? azurerm_linux_virtual_machine_scale_set.self_hosted_runners[0].id : azurerm_windows_virtual_machine_scale_set.self_hosted_runners[0].id
}
