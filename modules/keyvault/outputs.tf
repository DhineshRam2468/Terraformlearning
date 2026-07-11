output "vault_id"  { value = azurerm_key_vault.this.id }
output "vault_name" { value = azurerm_key_vault.this.name }
output "vault_uri"  { value = azurerm_key_vault.this.vault_uri }

output "sql_secret_id" {
  description = "Resource ID of the SQL password secret"
  value       = azurerm_key_vault_secret.sql_password.id
  sensitive   = true
}
