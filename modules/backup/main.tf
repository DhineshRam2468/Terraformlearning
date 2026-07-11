# ─────────────────────────────────────────────────────────────────────────────
# MODULE: BACKUP & SITE RECOVERY  (Week 6)
# Recovery Services Vault + VM backup policy + protected item per VM
# Site Recovery: conceptual only — full ASR lab requires 2 subscriptions/regions
# ─────────────────────────────────────────────────────────────────────────────

resource "azurerm_recovery_services_vault" "this" {
  name                = "rsv-${var.prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  soft_delete_enabled = true
  tags                = var.tags
}

resource "azurerm_backup_policy_vm" "daily" {
  name                = "policy-daily-${var.prefix}"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "02:00"   # 2 AM UTC daily backup
  }

  retention_daily {
    count = 7   # keep 7 daily restore points (free account cost conscious)
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }
}

resource "azurerm_backup_protected_vm" "this" {
  for_each            = var.vm_ids

  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  source_vm_id        = each.value
  backup_policy_id    = azurerm_backup_policy_vm.daily.id
}
