# Get current client configuration
data "azurerm_client_config" "current" {}

# Data source for existing Resource Group
data "azurerm_resource_group" "existing_rg" {
  #name = "your-existing-resource-group-name"
  name = "Regroup_7czMK_Ny6owa"
}
