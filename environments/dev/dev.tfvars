# ── Dev environment overrides ─────────────────────────────────────────────────
# Usage: terraform plan -var-file=environments/dev/dev.tfvars
environment = "dev"
vm_count    = 1           # save cost in dev
vm_size     = "Standard_B1s"
sql_sku     = "Basic"
common_tags = {
  project     = "sott-azure-training"
  managed_by  = "terraform"
  environment = "dev"
  owner       = "bharath"
}
