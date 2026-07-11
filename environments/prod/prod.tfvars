# ── Prod environment overrides ────────────────────────────────────────────────
# Usage: terraform plan -var-file=environments/prod/prod.tfvars
environment = "prod"
vm_count    = 2
vm_size     = "Standard_B2s"
sql_sku     = "S1"
common_tags = {
  project     = "sott-azure-training"
  managed_by  = "terraform"
  environment = "prod"
  owner       = "bharath"
}
