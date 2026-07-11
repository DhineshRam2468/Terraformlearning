variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "prefix"              { type = string }
variable "admin_username"      { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "sql_sku"             { type = string  default = "Basic" }
variable "allowed_dev_ip" {
  description = "Your public IP to allow SQL access (curl ifconfig.me)"
  type        = string
  default     = ""
}
variable "tags" { type = map(string) default = {} }
