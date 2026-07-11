output "vm_ids" {
  description = "Map of VM name -> VM resource ID (used by backup module)"
  value       = { for k, v in azurerm_linux_virtual_machine.this : k => v.id }
}

output "vm_private_ips" {
  description = "Map of VM name -> private IP address"
  value       = { for k, v in azurerm_network_interface.this : k => v.private_ip_address }
}

output "ssh_public_keys" {
  description = "Map of VM name -> SSH public key"
  value       = { for k, v in tls_private_key.ssh : k => v.public_key_openssh }
}
