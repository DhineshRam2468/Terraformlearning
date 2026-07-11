# SOTT Academy — 6-Week Azure + Terraform Training Project

> **Matches the 6-week weekend training plan (12 sessions × 120 min)**
> Each week's lab picks up a new module below. Terraform is used from Session 1 onward.

---

## Project Structure

```
azure-terraform-training/
├── main.tf                    ← root config calling all 9 modules
├── variables.tf               ← all input variable declarations
├── outputs.tf                 ← all root outputs
├── locals.tf                  ← computed locals (prefix, tags, subnet_ids)
├── versions.tf                ← provider + Terraform version pins + remote backend block
├── terraform.tfvars.example   ← copy → terraform.tfvars and fill in values
├── .gitignore
│
├── modules/
│   ├── network/               ← WEEK 1-2 │ VNet, Subnets, NSGs, VNet Peering
│   ├── loadbalancer/          ← WEEK 2   │ Standard LB, Backend Pool, Health Probe
│   ├── appgateway/            ← WEEK 3   │ App Gateway, Path-Based Routing, WAF_v2
│   ├── virtualmachine/        ← WEEK 3   │ Linux VMs (for_each), cloud-init, SSH keys
│   ├── storage/               ← WEEK 4   │ Storage Account, Containers, File Shares
│   ├── sql/                   ← WEEK 4   │ Azure SQL Server + Database
│   ├── keyvault/              ← WEEK 5   │ Key Vault, Secrets, RBAC
│   ├── apim/                  ← WEEK 5   │ API Management, Echo API, Policy
│   └── backup/                ← WEEK 6   │ Recovery Services Vault, VM Backup Policy
│
├── environments/
│   ├── dev/dev.tfvars         ← dev overrides (1 VM, Basic SQL)
│   └── prod/prod.tfvars       ← prod overrides (2 VMs, S1 SQL)
│
└── scripts/
    ├── bootstrap_backend.sh   ← WEEK 3 LAB: creates remote state storage
    ├── destroy_all.sh         ← safe destroy with confirmation prompt
    └── ssh_keys/              ← auto-generated SSH keys (gitignored)
```

---

## STEP-BY-STEP SETUP (First Time)

### STEP 0 — Prerequisites

Install these before Session 1:

| Tool | Command to verify | Install link |
|------|------------------|--------------|
| Terraform ≥ 1.5 | `terraform -version` | https://developer.hashicorp.com/terraform/install |
| Azure CLI | `az --version` | https://learn.microsoft.com/cli/azure/install-azure-cli |
| Git | `git --version` | https://git-scm.com |
| VS Code (recommended) | — | https://code.visualstudio.com |

VS Code extensions to install:
- **HashiCorp Terraform** (syntax highlighting + auto-complete)
- **Azure Tools** (resource browsing without leaving the editor)

---

### STEP 1 — Authenticate to Azure (Session 1, Day 1)

```bash
# Interactive login — opens a browser tab
az login

# Confirm you are on the correct subscription (free account)
az account show --output table

# If you have multiple subscriptions, set the right one:
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Verify Terraform can talk to Azure (should print your tenant/subscription)
az account get-access-token --output json
```

**Free account note:** Your free account gives you $200 credit + 12 months of select free services. The cheapest config in this project (1 VM Standard_B1s, Basic SQL, Consumption APIM, LRS storage) costs roughly **$5–15/month total** when running 24/7. Always run `terraform destroy` after each session.

---

### STEP 2 — Clone / Initialize the project

```bash
# Clone the repo (or unzip the project folder)
cd azure-terraform-training

# Copy the example tfvars and fill in your values
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars — at minimum set:
#   sql_admin_password = "something12chars!"
#   allowed_ip_for_kv  = "$(curl -s ifconfig.me)"
#   apim_publisher_email = "your@email.com"
```

---

### STEP 3 — terraform init (Session 1)

```bash
# Initialize — downloads the azurerm provider (~50 MB first time)
terraform init

# Format all .tf files consistently
terraform fmt -recursive

# Validate syntax
terraform validate

# Expected output: "Success! The configuration is valid."
```

---

### STEP 4 — First plan (Session 1 lab)

```bash
# See what Terraform will create — no changes made yet
terraform plan -out=tfplan

# Review the output:
# + azurerm_resource_group.main
# + module.network.azurerm_virtual_network.this
# ... (many more)
```

---

### STEP 5 — Apply week by week

The project is designed to be applied **incrementally by week**.
Use `-target` to apply only the current week's module during training.

```bash
# WEEK 1: Just the resource group
terraform apply -target=azurerm_resource_group.main

# WEEK 1-2: Network module
terraform apply -target=module.network

# WEEK 2: Add Load Balancer
terraform apply -target=module.loadbalancer

# WEEK 3: App Gateway + VMs
terraform apply -target=module.appgateway
terraform apply -target=module.virtualmachine

# WEEK 4: Storage + SQL
terraform apply -target=module.storage
terraform apply -target=module.sql

# WEEK 5: Key Vault + APIM
terraform apply -target=module.keyvault
terraform apply -target=module.apim

# WEEK 6: Backup
terraform apply -target=module.backup

# WEEK 6 CAPSTONE: Apply the full stack at once
terraform apply
```

---

### STEP 6 — Remote backend setup (Week 3 lab)

Run this once BEFORE activating the backend block in `versions.tf`:

```bash
# Creates the storage account that holds your tfstate
chmod +x scripts/bootstrap_backend.sh
./scripts/bootstrap_backend.sh eastus

# The script prints the storage account name.
# Copy it into the backend block in versions.tf (uncomment the block)
# Then migrate:
terraform init -migrate-state

# Verify state is now remote:
terraform state list
```

---

### STEP 7 — Destroy to save cost (after every session)

```bash
# Option A: use the helper script (prompts for confirmation)
./scripts/destroy_all.sh

# Option B: manual
terraform destroy -var-file=terraform.tfvars

# After destroy, verify in Azure Portal:
# Home > Resource Groups > rg-sott-dev should be empty or deleted
```

---

## WEEK-BY-WEEK LAB GUIDE

### Week 1 — Terraform Fundamentals + VNet

**What you learn:** init/plan/apply/destroy, provider block, variables, resource blocks, outputs

```bash
terraform init
terraform plan -target=azurerm_resource_group.main -target=module.network
terraform apply -target=azurerm_resource_group.main -target=module.network

# Inspect what was created
terraform output subnet_ids
terraform state list | grep network
```

**Portal check:** Home > Virtual Networks > `vnet-sott-dev` — verify address space and subnets

---

### Week 2 — NSGs + Load Balancer

```bash
# NSGs are part of the network module (already applied in Week 1)
# This week you focus on the LB:
terraform apply -target=module.loadbalancer

terraform output lb_public_ip
# curl that IP — you'll get a timeout (no VMs yet) — that's expected
terraform state show module.loadbalancer.azurerm_lb.this
```

---

### Week 3 — App Gateway + Virtual Machines + Remote Backend

```bash
# App Gateway (takes ~5 min)
terraform apply -target=module.appgateway

# VMs
terraform apply -target=module.virtualmachine

# SSH key is written to scripts/ssh_keys/vm-sott-dev-01.pem
ssh -i scripts/ssh_keys/vm-sott-dev-01.pem azureadmin@$(terraform output -json vm_private_ips | jq -r '."vm-sott-dev-01"')

# Verify nginx is running via LB
curl http://$(terraform output -raw lb_public_ip)

# Bootstrap remote state
./scripts/bootstrap_backend.sh eastus
# Then uncomment backend block in versions.tf and run:
terraform init -migrate-state
```

---

### Week 4 — Storage + SQL

```bash
terraform apply -target=module.storage
terraform apply -target=module.sql

# View outputs (connection string is sensitive — use -raw to see it)
terraform output -raw storage_primary_connection_string
terraform output sql_server_fqdn

# Connect to SQL from Azure Portal Query Editor or sqlcmd:
# sqlcmd -S <fqdn> -U sqladmin -P <password> -Q "SELECT @@VERSION"
```

---

### Week 5 — Key Vault + APIM + Multi-Environment

```bash
# Key Vault (requires your IP in allowed_ip_for_kv)
terraform apply -target=module.keyvault

# Verify secrets are stored
az keyvault secret list --vault-name $(terraform output -raw key_vault_uri | sed 's|https://||;s|/||')

# APIM (Consumption tier — instant)
terraform apply -target=module.apim
terraform output apim_gateway_url

# Test the echo API
curl "$(terraform output -raw apim_gateway_url)/echo/anything" -v

# Multi-environment demo:
terraform plan -var-file=environments/dev/dev.tfvars
terraform plan -var-file=environments/prod/prod.tfvars
# Compare the plans — see VM size and SQL SKU differ
```

---

### Week 6 — Backup + Full Capstone Apply

```bash
# Backup
terraform apply -target=module.backup

# Trigger on-demand backup via CLI
az backup protection backup-now \
  --resource-group rg-sott-dev \
  --vault-name $(terraform output -raw backup_vault_name) \
  --container-name $(terraform output -json vm_ids | jq -r 'keys[0]') \
  --item-name $(terraform output -json vm_ids | jq -r 'keys[0]') \
  --backup-management-type AzureIaasVM

# State commands practice
terraform state list
terraform state show module.backup.azurerm_recovery_services_vault.this
terraform state mv module.backup.azurerm_backup_policy_vm.daily module.backup.azurerm_backup_policy_vm.daily  # no-op example

# Full stack apply (capstone)
terraform apply

# Full destroy after capstone
./scripts/destroy_all.sh
```

---

## Terraform Concept Reference

| Concept | Where used in this project |
|---------|--------------------------|
| `provider` block | `versions.tf` — azurerm + random |
| `variable` + validation | `variables.tf`, every module's `variables.tf` |
| `locals` | `locals.tf` (prefix, tags) + `modules/appgateway/main.tf` |
| `for_each` | `modules/network/main.tf` (subnets), `modules/virtualmachine/main.tf` (VMs), `modules/storage/main.tf` (containers+shares), `modules/backup/main.tf` (protected VMs) |
| `count` | `modules/network/main.tf` (bastion subnet, peering) |
| `module {}` call | `main.tf` — 9 module calls |
| `output` | Every module `outputs.tf` + root `outputs.tf` |
| Remote backend | `versions.tf` (uncomment in Week 3) |
| `sensitive = true` | SQL password, storage connection string, KV secret |
| `data` source | `modules/keyvault/main.tf` (`azurerm_client_config.current`) |
| `depends_on` | `modules/keyvault/main.tf`, `modules/backup` in `main.tf` |
| `validation` block | `variables.tf` (environment, sql_admin_password, appgw_sku) |
| State commands | Week 6 lab: `state list`, `state show`, `state mv` |

---

## Cost Control Tips (Free Account)

| Resource | Cheapest option used | Est. monthly cost |
|----------|---------------------|------------------|
| 2 × VMs | Standard_B1s | ~$15 ($7.50 each) |
| SQL Database | Basic (5 DTU) | ~$5 |
| App Gateway | Standard_v2, capacity 1 | ~$20 (most expensive!) |
| Storage | LRS, Standard | <$1 |
| Key Vault | Standard | ~$0 |
| APIM | Consumption | ~$0 |
| Load Balancer | Standard | ~$18/month ($0.025/hr) |
| Backup | Standard vault | ~$0 for 7-day retention |

**Tip:** Comment out `module "appgateway"` in `main.tf` on weeks you aren't practicing App Gateway — it's the biggest cost driver. App Gateway takes 5 min to create/destroy so factor that into session timing.

---

## Common Errors & Fixes

| Error | Likely cause | Fix |
|-------|-------------|-----|
| `AuthorizationFailed` | Not logged in or wrong subscription | `az login` then `az account set` |
| `StorageAccountAlreadyTaken` | Storage account name taken globally | Change `project` variable to something unique |
| `KeyVaultNotFound` / `Forbidden` | Your IP not in KV network ACL | Update `allowed_ip_for_kv` in tfvars |
| `QuotaExceeded` | Free account vCPU limit (usually 4) | Reduce `vm_count` to 1 |
| `InvalidTemplateDeployment` on App GW | AppGW subnet too small | Ensure appgw subnet is /24 or /26 minimum |
| Backend init fails | Storage account not created yet | Run `bootstrap_backend.sh` first |

