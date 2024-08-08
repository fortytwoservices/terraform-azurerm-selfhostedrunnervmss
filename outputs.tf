output "password" {
  value     = local.password
  sensitive = true
}

output "virtual_machine_scale_set_id" {
  value = var.operating_system == "ubuntu" ? azurerm_linux_virtual_machine_scale_set.self_hosted_runners[0].id : azurerm_windows_virtual_machine_scale_set.self_hosted_runners[0].id
}

output "virtual_machine_scale_set_identity_principal_id" {
  value = var.operating_system == "ubuntu" ? azurerm_linux_virtual_machine_scale_set.self_hosted_runners[0].identity[0].principal_id : azurerm_windows_virtual_machine_scale_set.self_hosted_runners[0].identity[0].principal_id
}
