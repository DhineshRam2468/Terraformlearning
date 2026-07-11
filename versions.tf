terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # ─────────────────────────────────────────────────────────────────────────────
  # REMOTE BACKEND  (Week 3 activation)
  # Uncomment ONLY after running:  scripts/bootstrap_backend.sh
  # Then run:  terraform init -migrate-state
  # ─────────────────────────────────────────────────────────────────────────────
  # backend "azurerm" {
  #   resource_group_name  = "rg-tfstate-sott"
  #   storage_account_name = "sttfstatesottXXXXXX"   # printed by bootstrap_backend.sh
  #   container_name       = "tfstate"
  #   key                  = "dev/terraform.tfstate"
  # }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "random" {}
provider "tls"    {}
provider "local"  {}
