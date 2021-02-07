terraform {
  backend "azurerm" {
    resource_group_name  = "wize-tw-devops-rg"
    storage_account_name = "wizetwdevopsstorage"
    container_name = "terraform-states"
    key = "wize-environments.tfstate"
  }
}