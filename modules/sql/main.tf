# ─────────────────────────────────────────────────────────────────────────────
# MODULE: AZURE SQL  (Week 4)
# SQL Server + Database  |  Basic SKU for free account
# Password: sensitive variable (masked in plan output)
# Firewall: deny public by default, allow Azure services only
# ─────────────────────────────────────────────────────────────────────────────

resource "random_string" "sql_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_mssql_server" "this" {
  name                         = "sql-${var.prefix}-${random_string.sql_suffix.result}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  minimum_tls_version          = "1.2"

  tags = var.tags
}

resource "azurerm_mssql_database" "this" {
  name      = "db-${var.prefix}"
  server_id = azurerm_mssql_server.this.id
  sku_name  = var.sql_sku    # "Basic" = cheapest (free account friendly)
  tags      = var.tags
}

# Allow Azure services (e.g., App Service, VMs in same region)
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Your dev machine IP (set via allowed_dev_ip variable)
resource "azurerm_mssql_firewall_rule" "dev_machine" {
  count            = var.allowed_dev_ip != "" ? 1 : 0
  name             = "allow-dev-machine"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = var.allowed_dev_ip
  end_ip_address   = var.allowed_dev_ip
}
