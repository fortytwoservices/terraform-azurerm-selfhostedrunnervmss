output "password" {
  value     = local.password
  sensitive = true
}

output "virtual_machine_scale_set_id" {
  value = var.operating_system == "ubuntu" ? azapi_resource.vmss_linux[0].id : azapi_resource.vmss_windows[0].id
}

output "virtual_machine_scale_set_identity_principal_id" {
  value = var.identity != null ? (var.operating_system == "ubuntu" ? azapi_resource.vmss_linux[0].output.identity.principalId : azapi_resource.vmss_windows[0].output.identity.principalId) : "Identity is not enabled"
}

output "subnet_id" {
  value = var.subnet_id != null ? var.subnet_id : azapi_resource.vmss_subnet[0].id
}
