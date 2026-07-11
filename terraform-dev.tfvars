# ─────────────────────────────────────────────────────────────────────────────
# terraform.tfvars.example
# Copy to terraform.tfvars and fill in your values.
# NEVER commit terraform.tfvars to git (it is in .gitignore).
# ─────────────────────────────────────────────────────────────────────────────

location    = "East US"      # closest free-tier region to you
environment = "dev"
project     = "sott"

# ── VNet ─────────────────────────────────────────────────────────────────────
vnet_address_space = ["10.0.0.0/16"]
subnets = {
  web   = "10.0.1.0/24"
  app   = "10.0.2.0/24"
  data  = "10.0.3.0/24"
  appgw = "10.0.4.0/24"
}

# ── VMs ───────────────────────────────────────────────────────────────────────
vm_count         = 2
vm_size          = "Standard_B1s"   # free account: 750 hrs/month
vm_admin_username = "azureadmin"

# ── Storage ───────────────────────────────────────────────────────────────────
storage_containers = ["app-data", "logs"]
storage_shares     = { "shared-config" = 5 }

# ── SQL ───────────────────────────────────────────────────────────────────────
sql_admin_username = "sqladmin"
sql_admin_password = "CHANGE_ME_min12chars!"   # must meet Azure complexity rules
sql_sku            = "Basic"

# ── Key Vault ─────────────────────────────────────────────────────────────────
# Run: curl ifconfig.me  to get your IP
allowed_ip_for_kv = "YOUR.PUBLIC.IP.HERE"

# ── APIM ──────────────────────────────────────────────────────────────────────
apim_publisher_name  = "SOTT Academy"
apim_publisher_email = "your@email.com"

# ── Tags ──────────────────────────────────────────────────────────────────────
common_tags = {
  project    = "sott-azure-training"
  managed_by = "terraform"
  owner      = "bharath"
}
