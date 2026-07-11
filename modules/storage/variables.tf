variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "prefix"              { type = string }
variable "containers"          { type = list(string)   default = [] }
variable "shares"              { type = map(number)    default = {} }
variable "tags"                { type = map(string)    default = {} }
