# ── Uat environment overrides ─────────────────────────────────────────────────
# Usage: terraform plan -var-file=environments/uat/uat.tfvars
environment = "uat"
vm_count    = 1           # save cost in uat
vm_size     = "Standard_B1s"
sql_sku     = "Basic"
common_tags = {
  project     = "sott-azure-training"
  managed_by  = "terraform"
  environment = "uat"
  owner       = "dhinesh"
}
