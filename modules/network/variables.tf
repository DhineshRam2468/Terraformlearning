variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "prefix"              { type = string }
variable "vnet_address_space"  { type = list(string) }
variable "subnets"             { type = map(string) }
variable "tags" {
  type    = map(string)
  default = {}
}
variable "peer_vnet_id" {
  description = "Resource ID of a remote VNet to peer with (leave empty to skip)"
  type        = string
  default     = ""
}
