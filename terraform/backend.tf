# Create a random suffix for storage account name (must be globally unique)
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create resource group for storing state
resource "azurerm_resource_group" "terraform_state" {
  name     = "terraform-state-rg"
  location = "East US"
}

# Create storage account for state
resource "azurerm_storage_account" "terraform_state" {
  name                     = "tfstateacc${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create container for state
resource "azurerm_storage_container" "terraform_state" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
} 