variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "prefix"              { type = string }
variable "appgw_subnet_id"     { type = string }
variable "appgw_sku" {
  type    = string
  default = "Standard_v2"
  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.appgw_sku)
    error_message = "appgw_sku must be Standard_v2 or WAF_v2."
  }
}
variable "tags" { type = map(string) default = {} }
