#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# WEEK 3 LAB: Bootstrap Remote Terraform Backend
# Run this ONCE before activating the backend block in versions.tf
#
# What it creates:
#   - Resource group:   rg-tfstate-sott
#   - Storage account:  sttfstatesott<random>   (globally unique)
#   - Container:        tfstate
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

RG="rg-tfstate-sott"
LOCATION="${1:-eastus}"
SUFFIX=$(tr -dc 'a-z0-9' < /dev/urandom | head -c 6)
SA="sttfstatesott${SUFFIX}"
CONTAINER="tfstate"

echo "==> Creating resource group: $RG"
az group create --name "$RG" --location "$LOCATION" --output table

echo "==> Creating storage account: $SA"
az storage account create \
  --name "$SA" \
  --resource-group "$RG" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob \
  --output table

echo "==> Creating blob container: $CONTAINER"
az storage container create \
  --name "$CONTAINER" \
  --account-name "$SA" \
  --auth-mode login \
  --output table

echo ""
echo "────────────────────────────────────────────────────────────"
echo "Backend bootstrap complete. Update versions.tf backend block:"
echo "  storage_account_name = \"$SA\""
echo "  resource_group_name  = \"$RG\""
echo "  container_name       = \"$CONTAINER\""
echo "Then run: terraform init -migrate-state"
echo "────────────────────────────────────────────────────────────"
