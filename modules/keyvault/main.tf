# ─────────────────────────────────────────────────────────────────────────────
# MODULE: KEY VAULT  (Week 5)
# - RBAC-based access (modern approach over access policies)
# - Stores SQL admin password + storage connection string
# - sensitive = true on outputs so values never appear in logs
# ─────────────────────────────────────────────────────────────────────────────

data "azurerm_client_config" "current" {}

resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "this" {
  name                        = "kv-${replace(var.prefix, "-", "")}${random_string.kv_suffix.result}"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false   # true in prod; false for easy lab teardown
  enable_rbac_authorization   = true    # RBAC model (modern)

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = var.allowed_ip != "0.0.0.0" ? [var.allowed_ip] : []
  }

  tags = var.tags
}

# ── Grant the Terraform service principal Key Vault Officer ───────────────────
resource "azurerm_role_assignment" "tf_kv_officer" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# ── Store secrets ─────────────────────────────────────────────────────────────
resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-admin-password"
  value        = var.sql_admin_password
  key_vault_id = azurerm_key_vault.this.id
  tags         = var.tags

  depends_on = [azurerm_role_assignment.tf_kv_officer]
}

resource "azurerm_key_vault_secret" "storage_connection_string" {
  name         = "storage-connection-string"
  value        = var.storage_connection_string
  key_vault_id = azurerm_key_vault.this.id
  tags         = var.tags

  depends_on = [azurerm_role_assignment.tf_kv_officer]
}
