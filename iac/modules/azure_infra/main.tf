variable "name" {
  default = "ava-resources"
}

variable "location" {
  default = "East US"
}

resource "azurerm_resource_group" "ava" {
  name     = var.name
  location = var.location
}

resource "azurerm_network_security_group" "ava" {
  name                = "ava-nsg"
  location            = azurerm_resource_group.ava.location
  resource_group_name = azurerm_resource_group.ava.name
}

output "security_group" {
  value = azurerm_network_security_group.ava.name
}

output "resource_group" {
  value = azurerm_resource_group.ava.name
}

output "location" {
  value = azurerm_resource_group.ava.location
}
