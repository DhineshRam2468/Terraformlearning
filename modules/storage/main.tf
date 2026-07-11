# ─────────────────────────────────────────────────────────────────────────────
# MODULE: STORAGE  (Week 4)
# Storage account + blob containers (for_each) + file shares (for_each)
# ─────────────────────────────────────────────────────────────────────────────

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "this" {
  # Storage account names: 3-24 chars, lowercase alphanumeric only
  name                     = "st${replace(var.prefix, "-", "")}${random_string.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"   # cheapest – use GRS for prod
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  for_each             = toset(var.containers)
  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "this" {
  for_each             = var.shares
  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value   # GB
}
