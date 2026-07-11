variable "resource_group_name"       { type = string }
variable "location"                  { type = string }
variable "prefix"                    { type = string }
variable "allowed_ip"                { type = string  default = "0.0.0.0" }
variable "sql_admin_password" {
  type      = string
  sensitive = true
}
variable "storage_connection_string" {
  type      = string
  sensitive = true
}
variable "tags" { type = map(string) default = {} }
