output "appgw_id"         { value = azurerm_application_gateway.this.id }
output "public_ip_address" { value = azurerm_public_ip.appgw.ip_address }
