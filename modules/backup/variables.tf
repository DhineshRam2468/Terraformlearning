variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "prefix"              { type = string }
variable "vm_ids" {
  description = "Map of VM name -> VM resource ID (from virtualmachine module output)"
  type        = map(string)
  default     = {}
}
variable "tags" { type = map(string) default = {} }
