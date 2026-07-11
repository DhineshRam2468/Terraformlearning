# ─────────────────────────────────────────────────────────────────────────────
# ROOT VARIABLES  –  override in terraform.tfvars or environments/dev/dev.tfvars
# ─────────────────────────────────────────────────────────────────────────────

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Deployment environment (dev | prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be 'dev' or 'prod'."
  }
}

variable "project" {
  description = "Short project identifier — used in resource naming"
  type        = string
  default     = "sott"
}

# ── Networking ────────────────────────────────────────────────────────────────
variable "vnet_address_space" {
  description = "Address space for the main VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnet name -> CIDR"
  type        = map(string)
  default = {
    web     = "10.0.1.0/24"
    app     = "10.0.2.0/24"
    data    = "10.0.3.0/24"
    appgw   = "10.0.4.0/24"
    bastion = "AzureBastionSubnet" # Bastion needs this exact name
  }
}

# # ── Virtual Machine ───────────────────────────────────────────────────────────
# variable "vm_admin_username" {
#   description = "Admin username for Linux VMs"
#   type        = string
#   default     = "azureadmin"
# }

# variable "vm_size" {
#   description = "VM size (free account: Standard_B1s)"
#   type        = string
#   default     = "Standard_B1s"
# }

# variable "vm_count" {
#   description = "Number of backend VMs to deploy"
#   type        = number
#   default     = 2
# }

# # ── Storage ───────────────────────────────────────────────────────────────────
# variable "storage_containers" {
#   description = "List of blob container names to create"
#   type        = list(string)
#   default     = ["app-data", "logs"]
# }

# variable "storage_shares" {
#   description = "Map of file share name -> quota_gb"
#   type        = map(number)
#   default = {
#     "shared-config" = 5
#   }
# }

# # ── SQL ───────────────────────────────────────────────────────────────────────
# variable "sql_admin_username" {
#   description = "SQL Server administrator login"
#   type        = string
#   default     = "sqladmin"
# }

# variable "sql_admin_password" {
#   description = "SQL Server administrator password — mark sensitive, set in tfvars"
#   type        = string
#   sensitive   = true

#   validation {
#     condition     = length(var.sql_admin_password) >= 12
#     error_message = "sql_admin_password must be at least 12 characters."
#   }
# }

# variable "sql_sku" {
#   description = "SQL Database SKU (free account: Basic)"
#   type        = string
#   default     = "Basic"
# }

# # ── Key Vault ─────────────────────────────────────────────────────────────────
# variable "allowed_ip_for_kv" {
#   description = "Your public IP to allow Key Vault access (run: curl ifconfig.me)"
#   type        = string
#   default     = "0.0.0.0" # replace before applying
# }

# # ── APIM ──────────────────────────────────────────────────────────────────────
# variable "apim_publisher_name" {
#   description = "APIM publisher display name"
#   type        = string
#   default     = "SOTT Academy"
# }

# variable "apim_publisher_email" {
#   description = "APIM publisher email"
#   type        = string
#   default     = "admin@sott.academy"
# }

# ── Tags ──────────────────────────────────────────────────────────────────────
variable "common_tags" {
  description = "Tags applied to every resource"
  type        = map(string)
  default = {
    project     = "sott-azure-training"
    managed_by  = "terraform"
    owner       = "bharath"
  }
}
