# ─────────────────────────────────────────────────────────────────────────────
# ROOT OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "resource_group_name" {
  description = "Name of the main resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "VNet resource ID"
  value       = module.network.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet name -> subnet ID"
  value       = module.network.subnet_ids
}

# output "lb_public_ip" {
#   description = "Public IP of the Load Balancer"
#   value       = module.loadbalancer.public_ip_address
# }

# output "appgw_public_ip" {
#   description = "Public IP of the Application Gateway"
#   value       = module.appgateway.public_ip_address
# }

# output "vm_private_ips" {
#   description = "Map of VM name -> private IP"
#   value       = module.virtualmachine.vm_private_ips
# }

# output "storage_account_name" {
#   description = "Storage account name"
#   value       = module.storage.storage_account_name
# }

# output "storage_primary_connection_string" {
#   description = "Storage primary connection string"
#   value       = module.storage.primary_connection_string
#   sensitive   = true
# }

# output "sql_server_fqdn" {
#   description = "Fully qualified domain name of the SQL server"
#   value       = module.sql.server_fqdn
# }

# output "key_vault_uri" {
#   description = "Key Vault URI"
#   value       = module.keyvault.vault_uri
# }

# output "apim_gateway_url" {
#   description = "APIM Gateway URL"
#   value       = module.apim.gateway_url
# }

# output "backup_vault_name" {
#   description = "Recovery Services Vault name"
#   value       = module.backup.vault_name
# }
