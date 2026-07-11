variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "prefix"              { type = string }
variable "publisher_name"      { type = string  default = "SOTT Academy" }
variable "publisher_email"     { type = string  default = "admin@sott.academy" }
variable "apim_sku" {
  type    = string
  default = "Consumption"
  validation {
    condition     = contains(["Consumption", "Developer"], var.apim_sku)
    error_message = "Use Consumption (free account) or Developer."
  }
}
variable "apim_capacity" {
  type    = number
  default = 0   # 0 = Consumption tier (serverless)
}
variable "tags" { type = map(string) default = {} }
