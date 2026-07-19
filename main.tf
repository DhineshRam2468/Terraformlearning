# # ─────────────────────────────────────────────────────────────────────────────
# # RESOURCE GROUP
# # ─────────────────────────────────────────────────────────────────────────────
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.prefix}"
  location = var.location
  tags     = local.tags
}

# # ─────────────────────────────────────────────────────────────────────────────
# # WEEK 1-2 │ MODULE: NETWORK
# # VNet + Subnets + NSGs + VNet Peering (peer_vnet_id optional)
# # ─────────────────────────────────────────────────────────────────────────────
module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = local.prefix
  vnet_address_space  = var.vnet_address_space
  subnets             = var.subnets
  tags                = local.tags
}

# # ─────────────────────────────────────────────────────────────────────────────
# # WEEK 2 │ MODULE: LOAD BALANCER
# # Standard public LB fronting backend VMs
# # ─────────────────────────────────────────────────────────────────────────────
  module "loadbalancer" {
  source = "./modules/loadbalancer"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = local.prefix
  tags                = local.tags
}

# # ─────────────────────────────────────────────────────────────────────────────
# # WEEK 3 │ MODULE: APP GATEWAY
# # Application Gateway with WAF_v2 (or Standard_v2 for free account)
# # ─────────────────────────────────────────────────────────────────────────────
# module "appgateway" {
#   source = "./modules/appgateway"

#   resource_group_name = azurerm_resource_group.main.name
#   location            = var.location
#   prefix              = local.prefix
#   appgw_subnet_id     = local.subnet_ids["appgw"]
#   tags                = local.tags
# }

# # ─────────────────────────────────────────────────────────────────────────────
# # WEEK 3 │ MODULE: VIRTUAL MACHINE
# # Linux VMs using for_each; joined to LB backend pool
# # ─────────────────────────────────────────────────────────────────────────────
module "virtualmachine" {
  source = "./modules/virtualmachine"

  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  prefix                   = local.prefix
  subnet_id                = local.subnet_ids["web"]
  vm_count                 = var.vm_count
  vm_size                  = var.vm_size
  admin_username           = var.vm_admin_username
  lb_backend_pool_id       = module.loadbalancer.backend_pool_id
  tags                     = local.tags
}

# # ─────────────────────────────────────────────────────────────────────────────
# # WEEK 4 │ MODULE: STORAGE
# # Storage account + containers + file shares
# # ─────────────────────────────────────────────────────────────────────────────
module "storage" {
  source = "./modules/storage"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = local.prefix
  containers          = var.storage_containers
  shares              = var.storage_shares
  tags                = local.tags
}

# # ─────────────────────────────────────────────────────────────────────────────
# # WEEK 4 │ MODULE: SQL
# # Azure SQL Server + Database; password sourced from Key Vault after Week 5
# # ─────────────────────────────────────────────────────────────────────────────
# module "sql" {
#   source = "./modules/sql"

#   resource_group_name = azurerm_resource_group.main.name
#   location            = var.location
#   prefix              = local.prefix
#   admin_username      = var.sql_admin_username
#   admin_password      = var.sql_admin_password   # replaced by KV data source in Week 5
#   sql_sku             = var.sql_sku
#   tags                = local.tags
# }

# # ─────────────────────────────────────────────────────────────────────────────
# # WEEK 5 │ MODULE: KEY VAULT
# # Stores SQL password + storage connection string; referenced via data sources
# # ─────────────────────────────────────────────────────────────────────────────
# module "keyvault" {
#   source = "./modules/keyvault"

#   resource_group_name      = azurerm_resource_group.main.name
#   location                 = var.location
#   prefix                   = local.prefix
#   allowed_ip               = var.allowed_ip_for_kv
#   sql_admin_password       = var.sql_admin_password
#   storage_connection_string = module.storage.primary_connection_string
#   tags                     = local.tags

#   depends_on = [module.storage]
# }

# # ─────────────────────────────────────────────────────────────────────────────
# # WEEK 5 │ MODULE: APIM
# # Consumption-tier APIM (low cost, instant provision vs 30-min Developer tier)
# # ─────────────────────────────────────────────────────────────────────────────
# module "apim" {
#   source = "./modules/apim"

#   resource_group_name = azurerm_resource_group.main.name
#   location            = var.location
#   prefix              = local.prefix
#   publisher_name      = var.apim_publisher_name
#   publisher_email     = var.apim_publisher_email
#   tags                = local.tags
# }

# # ─────────────────────────────────────────────────────────────────────────────
# # WEEK 6 │ MODULE: BACKUP
# # Recovery Services Vault + VM backup policy + protected VM
# # ─────────────────────────────────────────────────────────────────────────────
# module "backup" {
#   source = "./modules/backup"

#   resource_group_name = azurerm_resource_group.main.name
#   location            = var.location
#   prefix              = local.prefix
#   vm_ids              = module.virtualmachine.vm_ids
#   tags                = local.tags

#   depends_on = [module.virtualmachine]
# }
