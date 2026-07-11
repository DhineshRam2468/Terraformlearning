variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "prefix"              { type = string }
variable "subnet_id"           { type = string }
variable "lb_backend_pool_id"  { type = string }
variable "vm_count"            { type = number  default = 2 }
variable "vm_size"             { type = string  default = "Standard_B1s" }
variable "admin_username"      { type = string  default = "azureadmin" }
variable "tags"                { type = map(string) default = {} }
