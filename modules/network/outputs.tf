output "vnet_id"    { value = azurerm_virtual_network.this.id }
output "vnet_name"  { value = azurerm_virtual_network.this.name }
output "subnet_ids" {
  value = { for k, s in azurerm_subnet.this : k => s.id }
}
output "nsg_web_id"  { value = azurerm_network_security_group.web.id }
output "nsg_app_id"  { value = azurerm_network_security_group.app.id }
output "nsg_data_id" { value = azurerm_network_security_group.data.id }
