terraform {
  backend "azurerm" {
    storage_account_name = "storage1222"
    resource_group_name = "Test"
    key = "terraform.tfstate"
    container_name = "container"
  }
}