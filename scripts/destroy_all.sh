#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# SAFE DESTROY SCRIPT — tears down the main deployment (not the backend RG)
# Run after each training session to control costs
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

echo "==> WARNING: This will destroy ALL resources in the current workspace"
echo "    Workspace: $(terraform workspace show)"
read -r -p "    Type 'yes' to confirm: " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "Aborted."
  exit 1
fi

terraform destroy -var-file=terraform.tfvars -auto-approve
echo ""
echo "==> Destroy complete. Verify in Azure Portal that resource group is gone."
